#!/usr/bin/env python3

import argparse
import json
import os
import platform
import sys
from pathlib import Path
from typing import Dict, List, Optional, Set, Union


def get_platform() -> str:
    """Get the current platform identifier."""
    system = platform.system().lower()
    if system == "darwin":
        return "darwin"
    elif system == "linux":
        return "linux"
    else:
        return system


def resolve_symlink_path(path: Path) -> Path:
    """Resolve a path to absolute for symlink creation."""
    return path.resolve()


def get_target_location(location: str) -> Path:
    """Resolve location string to actual directory path."""
    if location == "config":
        return Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    elif location == "home":
        return Path.home()
    elif location == "bin":
        return Path.home() / ".local" / "bin"
    else:
        raise ValueError(f"Unknown location: {location}")


class PackageConfig:
    """Configuration for a dotfiles package."""

    def __init__(self, name: str, path: Path, config_data: Optional[Dict] = None):
        self.name = name
        self.path = path

        # Set defaults
        config = config_data or {}
        self.platforms = config.get("platforms", [])
        self.location = config.get("location", "config")
        self.subdir = config.get("subdir", ".")  # "." means use package name
        self.files = config.get("files", None)  # None means all files
        self.exclude = config.get("exclude", [])
        self.ignore = config.get("ignore", False)

        # Warn about unknown fields
        known_fields = {"platforms", "location", "subdir", "files", "exclude", "ignore"}
        unknown_fields = set(config.keys()) - known_fields
        if unknown_fields:
            print(f"Warning: Unknown fields in {name}/dotfiles.json: {', '.join(unknown_fields)}")

        # Validate files mapping for top-level renames only
        if self.files and isinstance(self.files, dict):
            for source, target in self.files.items():
                if "/" in source or "\\" in source:
                    raise ValueError(f"Files mapping source must be top-level filename in {name}: {source}")
                if "/" in target or "\\" in target:
                    raise ValueError(f"Files mapping target must be top-level filename in {name}: {source} -> {target}")

    def is_platform_compatible(self, current_platform: str) -> bool:
        """Check if this package is compatible with the current platform."""
        return not self.platforms or current_platform in self.platforms

    def get_target_subdir(self) -> Optional[str]:
        """Get the resolved subdirectory name."""
        if self.subdir is None:
            return None
        elif self.subdir == ".":
            return self.name
        else:
            return self.subdir

    def get_source_files(self) -> Set[str]:
        """Get the set of source files to process."""
        if self.files is None:
            # All files in directory
            all_files = set()
            for item in self.path.iterdir():
                if item.name != "dotfiles.json":
                    all_files.add(item.name)
            return all_files
        elif isinstance(self.files, dict):
            if not self.files:
                # Empty dict means no files
                return set()
            else:
                # Use keys from files mapping
                return set(self.files.keys())
        else:
            return set()

    def get_target_filename(self, source_file: str) -> str:
        """Get target filename for a source file (top-level renames only)."""
        if self.files and isinstance(self.files, dict):
            target = self.files.get(source_file, source_file)
            # Validate that it's only a filename rename, not a path change
            if "/" in target or "\\" in target:
                raise ValueError(f"Files mapping only supports filename renames, not path changes: {source_file} -> {target}")
            return target
        return source_file

    def should_exclude_file(self, source_file: str) -> bool:
        """Check if a file should be excluded."""
        # files mapping takes precedence over exclude
        if self.files and isinstance(self.files, dict):
            return source_file not in self.files
        return source_file in self.exclude


def discover_packages(packages_dir: Path) -> List[PackageConfig]:
    """Discover all packages in the packages directory."""
    packages = []

    if not packages_dir.exists():
        print(f"Error: Packages directory {packages_dir} does not exist")
        sys.exit(2)

    for item in packages_dir.iterdir():
        if not item.is_dir():
            continue

        config_file = item / "dotfiles.json"
        config_data = None

        if config_file.exists():
            try:
                with open(config_file) as f:
                    config_data = json.load(f)
            except json.JSONDecodeError as e:
                print(f"Error: Invalid JSON in {config_file}: {e}")
                sys.exit(2)
            except Exception as e:
                print(f"Error: Could not read {config_file}: {e}")
                sys.exit(2)

        package = PackageConfig(item.name, item, config_data)
        packages.append(package)

    return packages


def install_package(package: PackageConfig, current_platform: str, dry_run: bool = False) -> bool:
    """Install or check a single package. Returns True if successful/installed."""
    if package.ignore:
        print(f"⏭ {package.name} (ignored)")
        return False

    if not package.is_platform_compatible(current_platform):
        if dry_run:
            print(f"⏭ {package.name} (platform mismatch)")
        return False

    # Ensure target location exists
    try:
        target_location = get_target_location(package.location)
        if not dry_run:
            target_location.mkdir(parents=True, exist_ok=True)
    except ValueError:
        print(f"⚠ {package.name} (skipped - invalid location)")
        return False
    except Exception as e:
        print(f"⚠ {package.name} (skipped - could not create target directory: {e})")
        return False

    # Get target directory
    target_subdir = package.get_target_subdir()
    if target_subdir:
        final_target_dir = target_location / target_subdir
        if not dry_run:
            final_target_dir.mkdir(parents=True, exist_ok=True)
    else:
        final_target_dir = target_location

    source_files = package.get_source_files()
    if not source_files:
        if dry_run:
            print(f"⚠ {package.name} (no files to install)")
        return False

    # Print package header (show cross only if no files to process)
    if not source_files:
        print(f"✗ {package.name}")
    else:
        print(f"{package.name}")

    # Process each file and print immediately
    success_count = 0
    for source_file in source_files:
        source_path = package.path / source_file

        if package.should_exclude_file(source_file):
            if dry_run:
                print(f"  - {source_file} (excluded)")
            continue

        if not source_path.exists():
            if dry_run:
                print(f"  ✗ {source_file} (source missing)")
            continue

        target_file = package.get_target_filename(source_file)
        target_path = final_target_dir / target_file

        # Analyze and handle current state
        if target_path.exists():
            if target_path.is_symlink():
                expected_target = resolve_symlink_path(source_path)
                actual_target = target_path.resolve()
                if actual_target == expected_target:
                    print(f"  ✓ {source_file} → {target_path} (present)")
                    success_count += 1
                    continue
                else:
                    print(f"  ⚠ {source_file} → {target_path} (wrong symlink target)")
                    continue
            else:
                print(f"  ⚠ {source_file} → {target_path} (file exists, not symlink)")
                continue
        else:
            if dry_run:
                print(f"  ✗ {source_file} → {target_path} (missing)")
                continue

        # Install mode: actually create the symlink
        if not dry_run:
            try:
                # Create the symlink
                absolute_source = resolve_symlink_path(source_path)
                target_path.symlink_to(absolute_source)
                print(f"  ✓ {source_file} → {target_path}")
                success_count += 1
            except Exception as e:
                print(f"  ✗ {source_file} → {target_path} (error: {e})")

    # Return success status
    return success_count > 0


def main():
    parser = argparse.ArgumentParser(
        description=f"Dotfiles manager (detected platform: {get_platform()})"
    )
    parser.add_argument(
        "--platform",
        default=get_platform(),
        help="Override platform detection"
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Check command
    check_parser = subparsers.add_parser("check", help="Check dotfiles status")

    # Install command
    install_parser = subparsers.add_parser("install", help="Install dotfiles")

    args = parser.parse_args()

    if args.command is None:
        parser.print_help()
        sys.exit(1)

    packages_dir = Path("packages")
    packages = discover_packages(packages_dir)

    if args.command == "check":
        for package in packages:
            install_package(package, args.platform, dry_run=True)
    elif args.command == "install":
        success_count = 0
        total_packages = 0
        for package in packages:
            if not package.ignore and package.is_platform_compatible(args.platform):
                total_packages += 1
                if install_package(package, args.platform, dry_run=False):
                    success_count += 1
        if total_packages > 0:
            print(f"\nSuccessfully installed {success_count}/{total_packages} packages")


if __name__ == "__main__":
    main()

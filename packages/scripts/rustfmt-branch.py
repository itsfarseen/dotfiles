#!/usr/bin/env python3
"""Check (and optionally fix) formatting for .rs files changed on the current branch."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

CHANNEL_RE = re.compile(r'^\s*channel\s*=\s*"([^"]+)"\s*$', re.MULTILINE)

# ANSI colors
_USE_COLOR = sys.stdout.isatty()

def _sgr(code: str) -> str:
    return f"\033[{code}m" if _USE_COLOR else ""

BOLD   = _sgr("1")
GREEN  = _sgr("32")
RED    = _sgr("31")
YELLOW = _sgr("33")
CYAN   = _sgr("36")
RESET  = _sgr("0")


def git_root() -> Path:
    return Path(
        subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            text=True,
        ).strip()
    )


def git_branch(cwd: Path) -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        text=True,
        cwd=cwd,
    ).strip()


def merge_base(base_ref: str, cwd: Path) -> str:
    return subprocess.check_output(
        ["git", "merge-base", "HEAD", base_ref],
        text=True,
        cwd=cwd,
    ).strip()


def changed_rs_files(merge_base_sha: str, repo: Path) -> list[Path]:
    names = subprocess.check_output(
        ["git", "diff", "--name-only", "--diff-filter=ACMR", f"{merge_base_sha}...HEAD"],
        text=True,
        cwd=repo,
    ).splitlines()
    paths: list[Path] = []
    for name in names:
        if not name.endswith(".rs"):
            continue
        path = repo / name
        if path.is_file():
            paths.append(path)
    return sorted(paths)


def parse_toolchain_channel(repo: Path) -> str:
    toml_path = repo / "rust-toolchain.toml"
    if toml_path.is_file():
        content = toml_path.read_text(encoding="utf-8")
        match = CHANNEL_RE.search(content)
        if match:
            return match.group(1)
        raise SystemExit(f"Could not find channel in {toml_path}")

    plain_path = repo / "rust-toolchain"
    if plain_path.is_file():
        channel = plain_path.read_text(encoding="utf-8").strip()
        if channel:
            return channel
        raise SystemExit(f"{plain_path} is empty")

    raise SystemExit(
        "No rust-toolchain.toml or rust-toolchain found at repository root"
    )


def rustfmt_binary(channel: str) -> str:
    try:
        return subprocess.check_output(
            ["rustup", "which", "--toolchain", channel, "rustfmt"],
            text=True,
        ).strip()
    except subprocess.CalledProcessError as exc:
        raise SystemExit(
            f"rustfmt not available for toolchain '{channel}'. "
            f"Install with: rustup toolchain install {channel}"
        ) from exc


def is_formatted(rustfmt: str, path: Path, repo: Path) -> bool:
    source = path.read_bytes()
    result = subprocess.run(
        [rustfmt, "--emit", "stdout"],
        input=source,
        capture_output=True,
        cwd=repo,
    )
    if result.returncode != 0:
        stderr = result.stderr.decode(errors="replace").strip()
        raise RuntimeError(f"rustfmt failed: {stderr or 'unknown error'}")
    return result.stdout == source


def format_file(channel: str, path: Path) -> None:
    subprocess.run(
        ["rustup", "run", channel, "rustfmt", str(path)],
        check=True,
    )


def rel(path: Path, repo: Path) -> str:
    try:
        return str(path.relative_to(repo))
    except ValueError:
        return str(path)


def print_group(title: str, mark: str, color: str, files: list[Path], repo: Path) -> None:
    print(f"{BOLD}{title}{RESET}")
    if not files:
        print(f"  {BOLD}(none){RESET}")
        return
    for path in files:
        print(f"  {color}{mark}{RESET} {rel(path, repo)}")


def prompt_format() -> bool:
    try:
        answer = input(f"{YELLOW}Format? [y/N]{RESET} ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print()
        return False
    return answer in ("y", "yes")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Check rustfmt on .rs files changed since branch diverged from main.",
    )
    parser.add_argument(
        "--base",
        default="origin/main",
        help="Git ref to compare against (default: origin/main)",
    )
    args = parser.parse_args()

    repo = git_root()
    branch = git_branch(repo)
    channel = parse_toolchain_channel(repo)
    rustfmt = rustfmt_binary(channel)

    base_sha = merge_base(args.base, repo)
    rs_files = changed_rs_files(base_sha, repo)

    print(f"{BOLD}Repository:{RESET}  {repo}")
    print(f"{BOLD}Branch:{RESET}      {CYAN}{branch}{RESET}")
    print(f"{BOLD}Toolchain:{RESET}   {channel}")
    print(f"{BOLD}Merge base:{RESET}  {base_sha} ({args.base})")
    print(f"{BOLD}Rust files:{RESET}  {len(rs_files)}")
    print()

    formatted: list[Path] = []
    unformatted: list[Path] = []
    errors: list[tuple[Path, str]] = []

    for path in rs_files:
        try:
            if is_formatted(rustfmt, path, repo):
                formatted.append(path)
            else:
                unformatted.append(path)
        except RuntimeError as exc:
            errors.append((path, str(exc)))

    print_group("Formatted", "✓", GREEN, formatted, repo)
    print()
    print_group("Unformatted", "✗", RED, unformatted, repo)

    if errors:
        print()
        print(f"{BOLD}Errors{RESET}")
        for path, message in errors:
            print(f"  {YELLOW}!{RESET} {rel(path, repo)}: {message}")

    if unformatted and sys.stdin.isatty():
        print()
        if prompt_format():
            print()
            for path in unformatted:
                print(f"  formatting {rel(path, repo)}")
                format_file(channel, path)
            print()
            print(f"{GREEN}Formatted {len(unformatted)} file(s).{RESET}")

    if errors:
        return 2
    if unformatted:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

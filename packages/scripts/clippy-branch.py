#!/usr/bin/env python3
"""Check clippy lints for .rs files changed on the current branch."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from collections import defaultdict
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


def rel(path: Path, repo: Path) -> str:
    try:
        return str(path.relative_to(repo))
    except ValueError:
        return str(path)


def run_clippy(channel: str, repo: Path) -> list[dict]:
    """Run clippy with JSON output and return parsed diagnostic messages."""
    result = subprocess.run(
        [
            "rustup", "run", channel,
            "cargo", "clippy",
            "--message-format=json",
            "--all-targets",
        ],
        capture_output=True,
        text=True,
        cwd=repo,
    )
    # clippy returns non-zero on warnings/errors, which is expected
    messages = []
    for line in result.stdout.splitlines():
        if not line.startswith("{"):
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue
        if obj.get("reason") == "compiler-message":
            messages.append(obj["message"])
    return messages


def filter_diagnostics(
    messages: list[dict],
    changed: set[Path],
    repo: Path,
) -> dict[Path, list[dict]]:
    """Filter diagnostics to only those with a primary span in a changed file."""
    by_file: dict[Path, list[dict]] = defaultdict(list)
    seen: set[str] = set()
    for msg in messages:
        for span in msg.get("spans", []):
            if not span.get("is_primary", False):
                continue
            file_path = (repo / span["file_name"]).resolve()
            if file_path in changed:
                # deduplicate by rendered text
                rendered = msg.get("rendered", "")
                if rendered in seen:
                    break
                seen.add(rendered)
                by_file[file_path].append(msg)
                break
    return dict(by_file)


def count_by_level(diagnostics: list[dict]) -> tuple[int, int]:
    """Return (warning_count, error_count) for a list of diagnostics."""
    warnings = sum(1 for d in diagnostics if d.get("level") == "warning")
    errors = sum(1 for d in diagnostics if d.get("level") == "error")
    return warnings, errors


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Check clippy lints on .rs files changed since branch diverged from main.",
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

    base_sha = merge_base(args.base, repo)
    rs_files = changed_rs_files(base_sha, repo)
    changed_set = {p.resolve() for p in rs_files}

    print(f"{BOLD}Repository:{RESET}  {repo}")
    print(f"{BOLD}Branch:{RESET}      {CYAN}{branch}{RESET}")
    print(f"{BOLD}Toolchain:{RESET}   {channel}")
    print(f"{BOLD}Merge base:{RESET}  {base_sha} ({args.base})")
    print(f"{BOLD}Rust files:{RESET}  {len(rs_files)}")
    print()

    if not rs_files:
        print(f"{GREEN}No .rs files changed on this branch.{RESET}")
        return 0

    print(f"Running clippy...")
    print()

    messages = run_clippy(channel, repo)
    by_file = filter_diagnostics(messages, changed_set, repo)

    # Print diagnostics
    if by_file:
        for path in sorted(by_file):
            for msg in by_file[path]:
                rendered = msg.get("rendered", "")
                if rendered:
                    print(rendered, end="" if rendered.endswith("\n") else "\n")
        print()

    # Summary
    total_warnings = 0
    total_errors = 0

    print(f"{BOLD}Summary{RESET}")
    for path in sorted(rs_files):
        resolved = path.resolve()
        if resolved in by_file:
            diagnostics = by_file[resolved]
            w, e = count_by_level(diagnostics)
            total_warnings += w
            total_errors += e
            parts = []
            if e:
                parts.append(f"{e} error{'s' if e != 1 else ''}")
            if w:
                parts.append(f"{w} warning{'s' if w != 1 else ''}")
            label = ", ".join(parts)
            print(f"  {RED}✗{RESET} {rel(path, repo)} ({label})")
        else:
            print(f"  {GREEN}✓{RESET} {rel(path, repo)}")

    total = total_warnings + total_errors
    if total:
        print()
        parts = []
        if total_errors:
            parts.append(f"{total_errors} error{'s' if total_errors != 1 else ''}")
        if total_warnings:
            parts.append(f"{total_warnings} warning{'s' if total_warnings != 1 else ''}")
        summary = ", ".join(parts)
        file_count = len(by_file)
        print(f"  {RED}{summary} in {file_count} file{'s' if file_count != 1 else ''}{RESET}")
    else:
        print()
        print(f"  {GREEN}All changed files are clean!{RESET}")

    if total_errors:
        return 2
    if total_warnings:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

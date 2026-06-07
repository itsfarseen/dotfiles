#!/usr/bin/env python3

import os
import subprocess
import tempfile
from collections import defaultdict
from pathlib import Path


MAX_FILE_CHARS = 20_000
MAX_PROMPT_CHARS = 1_000_000


def run(cmd, **kwargs):
    return subprocess.run(cmd, capture_output=True, text=True, check=True, **kwargs).stdout


def summarize_file_content(path: Path) -> str:
    try:
        content = path.read_text()
    except (OSError, UnicodeDecodeError):
        return ""

    if len(content) <= MAX_FILE_CHARS:
        return content

    head = content[:MAX_FILE_CHARS]
    return f"{head}\n\n[truncated {len(content) - MAX_FILE_CHARS} characters from {path}]\n"


def count_lines(text: str) -> int:
    if not text:
        return 0
    return text.count("\n") + (0 if text.endswith("\n") else 1)


def package_name(path: str) -> str | None:
    parts = Path(path).parts
    if len(parts) >= 2 and parts[0] == "packages":
        return parts[1]
    return None


def build_untracked_package_index(untracked_files):
    package_files = defaultdict(list)
    for path in untracked_files:
        pkg = package_name(path)
        if pkg is None:
            continue
        package_files[pkg].append(path)
    return package_files


def batch_prompt(prompt_text: str, git_status: str, tracked_files, untracked_files) -> str:
    batch_diff = ""
    for path in tracked_files:
        batch_diff += run(["git", "diff", "--", path])

    untracked_content = ""
    for f in untracked_files:
        content = summarize_file_content(Path(f))
        untracked_content += f"=== {f} ===\n{content}\n"

    return f"""{prompt_text}

## Current repo state

### git status
{git_status}

### git diff
{batch_diff}

### Untracked files content
{untracked_content}"""


def prompt_preview(tracked_files, untracked_files, ignored_packages, untracked_package_files):
    print("Prompt preview:")
    for path in tracked_files:
        diff = run(["git", "diff", "--", path])
        print(f"- {path}: {count_lines(diff)} lines")
    for path in untracked_files:
        if any(path in untracked_package_files[pkg] for pkg in ignored_packages):
            continue
        content = summarize_file_content(Path(path))
        line_count = count_lines(content)
        print(f"- {path}: {line_count} lines")
    if ignored_packages:
        print("Ignored untracked packages:")
        for pkg in ignored_packages:
            print(f"- packages/{pkg}/")


def main():
    script_dir = Path(__file__).resolve().parent
    os.chdir(script_dir.parent)

    prompt_text = (script_dir / "prompt.txt").read_text()
    git_status = run(["git", "status"])

    tracked_files = run(["git", "diff", "--name-only"]).splitlines()
    untracked_files = run(["git", "ls-files", "--others", "--exclude-standard"]).splitlines()

    untracked_package_files = build_untracked_package_index(untracked_files)
    tracked_packages = {pkg for pkg in (package_name(path) for path in tracked_files) if pkg is not None}
    ignored_packages = sorted(
        pkg for pkg, files in untracked_package_files.items() if pkg not in tracked_packages
    )
    ignored_files = []
    for pkg in ignored_packages:
        ignored_files.extend(untracked_package_files[pkg])

    if ignored_packages:
        print("Ignoring entirely untracked packages:")
        for pkg in ignored_packages:
            print(f"- packages/{pkg}/ ({len(untracked_package_files[pkg])} files)")

    remaining_tracked_files = [f for f in tracked_files if f]
    remaining_untracked_files = [f for f in untracked_files if f and f not in ignored_files]
    prompt_preview(remaining_tracked_files, remaining_untracked_files, ignored_packages, untracked_package_files)
    full_prompt = batch_prompt(prompt_text, git_status, remaining_tracked_files, remaining_untracked_files)
    prompt_length = len(full_prompt)
    print(f"Prompt length: {prompt_length} characters")
    if prompt_length > MAX_PROMPT_CHARS:
        raise RuntimeError(
            f"prompt exceeds Codex limit: {prompt_length} characters (max {MAX_PROMPT_CHARS})"
        )

    with tempfile.NamedTemporaryFile(mode="w+", delete=False) as tmp:
        output_path = Path(tmp.name)

    try:
        codex_run = subprocess.run(
            ["codex", "exec", "--model", "gpt-5.4-mini", "--output-last-message", str(output_path), "-"],
            input=full_prompt,
            text=True,
            capture_output=True,
        )
        if codex_run.returncode != 0:
            raise subprocess.CalledProcessError(
                codex_run.returncode,
                codex_run.args,
                output=codex_run.stdout,
                stderr=codex_run.stderr,
            )
        result = output_path.read_text().strip()
    finally:
        try:
            output_path.unlink()
        except FileNotFoundError:
            pass

    commits_path = script_dir / "commits-codex.sh"
    commits_path.write_text(result)

    print(f"Generated {commits_path}")
    print("---")
    print(result, end="")
    print("---")
    print(f"Review above, then run: bash {commits_path}")


if __name__ == "__main__":
    main()

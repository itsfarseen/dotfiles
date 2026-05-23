#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path


def run(cmd, **kwargs):
    return subprocess.run(cmd, capture_output=True, text=True, check=True, **kwargs).stdout


def main():
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent
    os.chdir(repo_root)

    prompt_text = (script_dir / "prompt.txt").read_text()

    git_status = run(["git", "status"])
    git_diff = run(["git", "diff"])

    untracked_files = run(["git", "ls-files", "--others", "--exclude-standard"]).splitlines()
    untracked_content = ""
    for f in untracked_files:
        if not f:
            continue
        try:
            content = Path(f).read_text()
        except (OSError, UnicodeDecodeError):
            content = ""
        untracked_content += f"=== {f} ===\n{content}\n"

    full_prompt = f"""{prompt_text}

## Current repo state

### git status
{git_status}

### git diff
{git_diff}

### Untracked files content
{untracked_content}"""

    result = run(["claude", "-p", full_prompt])

    commits_path = script_dir / "commits.sh"
    commits_path.write_text(result)

    print(f"Generated {commits_path}")
    print("---")
    print(result, end="")
    print("---")
    print(f"Review above, then run: bash {commits_path}")


if __name__ == "__main__":
    main()

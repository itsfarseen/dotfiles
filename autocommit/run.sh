#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

prompt="$(cat "$SCRIPT_DIR/prompt.txt")

## Current repo state

### git status
$(git status)

### git diff
$(git diff)

### Untracked files content
$(git ls-files --others --exclude-standard | while IFS= read -r f; do echo "=== $f ==="; cat "$f" 2>/dev/null; echo; done)"

claude -p "$prompt" > "$SCRIPT_DIR/commits.sh"
echo "Generated $SCRIPT_DIR/commits.sh"
echo "---"
cat "$SCRIPT_DIR/commits.sh"
echo "---"
echo "Review above, then run: bash $SCRIPT_DIR/commits.sh"

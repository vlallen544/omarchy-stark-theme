#!/usr/bin/env bash
set -euo pipefail

# This bootstrapper intentionally contains no install logic. It downloads the
# repository, then runs the versioned installer that can be reviewed on GitHub.
repo_url="${STARK_REPO_URL:-https://github.com/vlallen544/omarchy-stark-theme.git}"
work_dir=$(mktemp -d)

cleanup() {
    rm -rf -- "$work_dir"
}
trap cleanup EXIT

if ! command -v git >/dev/null 2>&1; then
    printf 'Missing required command: git\n' >&2
    exit 1
fi

git clone --depth=1 "$repo_url" "$work_dir/omarchy-stark-theme"
"$work_dir/omarchy-stark-theme/install.sh"

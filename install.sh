#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"

if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
    echo "backing up existing nvim config to $NVIM_DIR.bak"
    mv "$NVIM_DIR" "$NVIM_DIR.bak"
fi

ln -sfn "$REPO_DIR" "$NVIM_DIR"

echo "nvim config linked to $REPO_DIR"
echo "open nvim to trigger lazy.nvim plugin install."

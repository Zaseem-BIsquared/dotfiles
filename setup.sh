#!/bin/bash
# Dotfiles setup — run this on a fresh Mac.
# Usage: curl -sL https://raw.githubusercontent.com/Zaseem-BIsquared/dotfiles/master/setup.sh | bash
# — or —
# bash ~/setup.sh

set -e

DOTFILES_REPO="https://github.com/Zaseem-BIsquared/dotfiles.git"
CFG_DIR="$HOME/.cfg"

echo "=== Dotfiles Setup ==="

# ── 1. Clone bare repo & checkout ──
if [ ! -d "$CFG_DIR" ]; then
  echo ""
  echo "Cloning dotfiles bare repo..."
  git clone --bare "$DOTFILES_REPO" "$CFG_DIR"

  if ! git --git-dir="$CFG_DIR" --work-tree="$HOME" checkout 2>/dev/null; then
    echo "Backing up conflicting files to ~/.dotfiles-backup..."
    mkdir -p ~/.dotfiles-backup
    git --git-dir="$CFG_DIR" --work-tree="$HOME" checkout 2>&1 \
      | grep "^\t" | awk '{print $1}' \
      | xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname "{}") && mv "$HOME/{}" ~/.dotfiles-backup/{}'
    git --git-dir="$CFG_DIR" --work-tree="$HOME" checkout
  fi

  git --git-dir="$CFG_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no
  git --git-dir="$CFG_DIR" --work-tree="$HOME" config --local core.excludesFile ~/.cfg-ignore
  echo "Dotfiles checked out."
else
  echo "Dotfiles repo already exists at $CFG_DIR"
fi

# ── 2. Install npm packages (Claude Code frameworks) ──
echo ""
if command -v npm &>/dev/null; then
  echo "Installing Claude Code frameworks..."
  npm install -g feather-flow get-shit-done-cc 2>/dev/null || echo "  (npm install failed — install manually)"
else
  echo "npm not found — install Node.js first, then run:"
  echo "  npm install -g feather-flow get-shit-done-cc"
fi

echo ""
echo "=== Done! Open a new terminal to load everything. ==="

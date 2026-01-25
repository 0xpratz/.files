#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.files"
CONFIG="$HOME/.config"

echo "Installing dotfiles from: $DOTFILES"

# ---- sanity checks -------------------------------------------------

if [[ ! -d "$DOTFILES" ]]; then
  echo "ERROR: $DOTFILES does not exist"
  exit 1
fi

# ---- files ---------------------------------------------------------

ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

# ---- directories ---------------------------------------------------

mkdir -p "$CONFIG"

for dir in nvim tmux; do
  if [[ -e "$CONFIG/$dir" || -L "$CONFIG/$dir" ]]; then
    rm -rf "$CONFIG/$dir"
  fi
  ln -s "$DOTFILES/.config/$dir" "$CONFIG/$dir"
done

# ---- verification --------------------------------------------------

echo
echo "Installed symlinks:"
ls -l "$HOME/.zshrc"
ls -ld "$CONFIG/nvim" "$CONFIG/tmux"

echo
echo "Dotfiles installed successfully."

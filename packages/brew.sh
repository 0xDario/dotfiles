#!/usr/bin/env bash
# macOS packages via Homebrew
set -euo pipefail

PROFILE="${1:-full}"

PKGS=(
  git
  curl
  eza
  bat
  fd
  ripgrep
  zoxide
  starship
  du-dust
  fzf
)

# Full profile: heavier TUI tools
if [[ "$PROFILE" != "server" ]]; then
  PKGS+=(
    ranger
    bottom
    gitui
  )
fi

brew install "${PKGS[@]}"

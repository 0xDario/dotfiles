#!/usr/bin/env bash
# Symlink dotfiles into place
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  # Back up existing real files (not symlinks) before overwriting
  [[ -e "$dst" && ! -L "$dst" ]] && mv "$dst" "$dst.bak.$(date +%s)"
  ln -sfn "$src" "$dst"
  echo "  linked: $dst"
}

echo "==> Symlinking dotfiles"

link "$DOTFILES/zsh/.zshrc"           "$HOME/.zshrc"
link "$DOTFILES/zsh/.zsh_aliases"     "$HOME/.zsh_aliases"
link "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"

# macOS only
if [[ "$(uname)" == "Darwin" ]]; then
  link "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
fi

echo "Done."

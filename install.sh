#!/usr/bin/env bash
# Dotfiles installer — macOS and Linux
# Usage: bash install.sh [--profile server|full]
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="full"
OS="$(uname)"

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile=*) PROFILE="${1#*=}" ;;
    --profile)   PROFILE="${2:-full}"; shift ;;
  esac
  shift
done

echo "==> Dotfiles install | OS: $OS | Profile: $PROFILE"
echo ""

# ── System packages ─────────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  echo "==> Installing Homebrew packages"
  command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  bash "$DOTFILES/packages/brew.sh" "$PROFILE"

elif [[ "$OS" == "Linux" ]]; then
  echo "==> Installing apt packages"
  bash "$DOTFILES/packages/apt.sh" "$PROFILE"

  echo "==> Installing Rust toolchain"
  if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env"
  fi

  echo "==> Installing cargo-binstall"
  if ! command -v cargo-binstall &>/dev/null; then
    curl -L --proto '=https' --tlsv1.2 -sSf \
      https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  fi

  echo "==> Installing Rust CLI tools"
  bash "$DOTFILES/packages/cargo.sh" "$PROFILE"
fi

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
echo "==> Installing Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "==> Installing zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "==> Installing zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────
echo "==> Creating symlinks"
bash "$DOTFILES/symlinks.sh"

# ── Default shell ────────────────────────────────────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "==> Changing default shell to zsh"
  # Add zsh to /etc/shells if not present (common on Linux)
  grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH"
fi

echo ""
echo "All done! Open a new terminal or run: exec zsh"

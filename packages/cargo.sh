#!/usr/bin/env bash
# Rust CLI tools via cargo-binstall (falls back to cargo install)
set -euo pipefail

PROFILE="${1:-full}"

# Ensure cargo is on PATH
source "$HOME/.cargo/env" 2>/dev/null || true

binstall() {
  local crate="$1"
  local bin="${2:-$1}"  # binary name may differ from crate name (e.g. fd-find -> fd)
  if command -v "$bin" &>/dev/null; then
    echo "==> Skipping $crate (already installed)"
    return 0
  fi
  echo "==> Installing $crate"
  cargo binstall --no-confirm --locked "$crate" \
    || cargo install --locked "$crate"
}

# Core tools — all profiles
binstall bat        bat
binstall eza        eza
binstall fd-find    fd
binstall ripgrep    rg
binstall zoxide     zoxide
binstall starship   starship
binstall du-dust    dust

# Full profile only
if [[ "$PROFILE" != "server" ]]; then
  binstall bottom   btm
  binstall gitui    gitui
fi

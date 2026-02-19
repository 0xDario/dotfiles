#!/usr/bin/env bash
# Linux system packages via apt
set -euo pipefail

PROFILE="${1:-full}"

sudo apt-get update -qq
sudo apt-get install -y \
  zsh \
  git \
  curl \
  unzip \
  build-essential \
  fzf

# Full profile: ranger (Python TUI file manager)
if [[ "$PROFILE" != "server" ]]; then
  sudo apt-get install -y ranger
fi

# dotfiles

Cross-platform dotfiles for macOS and Linux with a one-command bootstrap.

## What's included

| Tool | Purpose |
|------|---------|
| [Oh My Zsh](https://ohmyz.sh) | Zsh framework + plugins |
| [Starship](https://starship.rs) | Cross-shell prompt |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [eza](https://github.com/eza-community/eza) | Modern `ls` |
| [fd](https://github.com/sharkdp/fd) | Fast `find` alternative |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` alternative |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |
| [du-dust](https://github.com/bootandy/dust) | Intuitive `du` |
| [bottom](https://github.com/ClementTsang/bottom) | Modern `htop` |
| [gitui](https://github.com/extrawurst/gitui) | Terminal Git UI |
| [ranger](https://ranger.github.io) | Terminal file manager |

## Install

```bash
git clone https://github.com/darioturchi/dotfiles ~/dotfiles
bash ~/dotfiles/install.sh
```

For a Linux server (skips heavier TUI tools):

```bash
bash ~/dotfiles/install.sh --profile server
```

The installer handles:
- Homebrew (macOS) or apt + Rust toolchain (Linux)
- Oh My Zsh + zsh-autosuggestions, zsh-syntax-highlighting, zsh-autocomplete
- All CLI tools via Homebrew or cargo-binstall
- Symlinking configs into place (backs up any existing files automatically)
- Setting zsh as the default shell

## Structure

```
dotfiles/
├── install.sh          # Main entry point
├── symlinks.sh         # Symlinks configs into ~/
├── packages/
│   ├── brew.sh         # macOS packages
│   ├── apt.sh          # Linux packages
│   └── cargo.sh        # Rust CLI tools
├── zsh/
│   ├── .zshrc          # Main shell config
│   ├── .zsh_aliases    # Aliases
│   └── .zprofile       # macOS login shell config
└── config/
    └── starship.toml   # Prompt config
```

## Manual setup (existing machine)

If you're already on macOS with zsh and Homebrew, skip the full installer and just symlink:

```bash
bash ~/dotfiles/symlinks.sh
exec zsh
```

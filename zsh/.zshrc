############################################################
# 0. Early exit for non-interactive shells
############################################################
[[ -o interactive ]] || return
typeset -U path PATH


############################################################
# 1. Homebrew (platform-aware)
############################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Apple Silicon: /opt/homebrew, Intel: /usr/local
  if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi
elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  # GNU coreutils — Linux-compatible tools on macOS
  if [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  fi
fi


############################################################
# 2. Rust / Cargo
############################################################
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"


############################################################
# 3. Shell history
############################################################
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE


############################################################
# 4. Oh My Zsh
############################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Starship handles the prompt

plugins=(
  git
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"


############################################################
# 5. Completion enhancements (Homebrew-installed plugins)
############################################################
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi


############################################################
# 6. Starship prompt
############################################################
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi


############################################################
# 7. zoxide (smart directory jumping)
############################################################
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi


############################################################
# 8. User-local binaries
############################################################
export PATH="$HOME/.local/bin:$PATH"


############################################################
# 9. pnpm (platform-aware)
############################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"


############################################################
# 10. Platform-specific extras
############################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  # JetBrains Toolbox scripts
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  # opencode
  export PATH="$HOME/.opencode/bin:$PATH"
fi


############################################################
# 11. Aliases
############################################################
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"


############################################################
# 12. Quality-of-life tweaks
############################################################
setopt EXTENDED_GLOB
setopt IGNORE_EOF
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

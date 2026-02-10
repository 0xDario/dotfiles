############################################################
# 0. Early exit for non-interactive shells
# (Prevents PATH hacks from breaking scripts)
############################################################
[[ -o interactive ]] || return
typeset -U path PATH


############################################################
# 1. Homebrew environment
############################################################
export HOMEBREW_PREFIX="/opt/homebrew"


############################################################
# 2. GNU coreutils (Linux-compatible tools)
# Safe: interactive shells only, no system overwrite
############################################################
if [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]]; then
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi


############################################################
# 3. Shell history (fast, shared, predictable)
############################################################
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY          # don’t overwrite history
setopt INC_APPEND_HISTORY      # write history immediately
setopt SHARE_HISTORY           # share between tabs
setopt HIST_IGNORE_ALL_DUPS    # no duplicate spam
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE       # commands starting with space aren’t saved


############################################################
# 4. Oh My Zsh
############################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
)

source "$ZSH/oh-my-zsh.sh"


############################################################
# 5. Completion enhancements
############################################################
# zsh-autocomplete (brew-installed)
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi


############################################################
# 6. Better defaults (aliases)
############################################################
# NOTE: Avoid aliasing core behavior in scripts
# These are interactive quality-of-life only

alias cat="bat"
alias ll="eza -lao --git-repos --header --icons"
alias ls="eza"


############################################################
# 7. zoxide (smart directory jumping)
############################################################
eval "$(zoxide init zsh)"
# Use `z` explicitly; do NOT alias cd (safer)


############################################################
# 8. User-local binaries
############################################################
export PATH="$HOME/.local/bin:$PATH"


############################################################
# 9. pnpm (single source of truth)
############################################################
export PNPM_HOME="$HOME/Library/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
  export PATH="$PNPM_HOME:$PATH"
fi


############################################################
# 10. Quality-of-life tweaks
############################################################
# Faster globbing
setopt EXTENDED_GLOB

# Better Ctrl+D behavior
setopt IGNORE_EOF

# Make tab completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


############################################################
# 11. Debug helpers (optional)
############################################################
# See where commands resolve from
alias whichall='type -a'

# Reload config
alias reload='source ~/.zshrc'

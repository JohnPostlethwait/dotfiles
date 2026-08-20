# Zsh configuration.

export PATH="$HOME/go/bin:$PATH"

# Turn off annoying Docker and Homebrew ads
export DOCKER_CLI_HINTS=false
export HOMEBREW_NO_ENV_HINTS=1

# Source modular configuration.
source "$HOME/.config/zsh/env.zsh"
source "$HOME/.config/zsh/aliases.zsh"

# Source functions.
source "$HOME/.bin/copy.sh"

# Prompt — Starship (config at ~/.config/starship.toml).
eval "$(starship init zsh)"

# Completions.
source "$HOME/.config/zsh/completions.zsh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# History.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
unsetopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
export PATH="$HOME/.local/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Claude Multi-Account

alias claude1="CLAUDE_CONFIG_DIR=~/.claude-ellmtree claude"
alias claude2="CLAUDE_CONFIG_DIR=~/.claude claude"


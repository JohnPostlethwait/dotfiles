# Initialize zsh completion system.
autoload -Uz compinit

# Only regenerate .zcompdump once per day for faster shell startup.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Homebrew zsh completions are auto-discovered via FPATH set by brew shellenv.

# Case-insensitive completion matching.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Completion menu with highlighting.
zstyle ':completion:*' menu select

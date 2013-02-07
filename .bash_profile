cd ~/Documents/workspace

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[01;34m\]"
PINK='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
GREY="\[\033[37m\]"
BLACK="\[\033[38m\]"

export PS1="$BLUE\$(date +%I:%M:%S%p) $RED\w$YELLOW\$(parse_git_branch)$GREY: "

alias l='ls -lah'
alias g='git'

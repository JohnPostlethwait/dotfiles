cd Documents/workspace

BOLD=`tput bold`

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (git branch\: \1)/'
}


RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[01;34m\]"
GREY="\[\033[37m\]"
BLACK="\[\033[38m\]"
CYAN='\[\033[0;36m\]'
PURPLE='\[\033[0;35m\]'

export PS1="$BLUE$BOLD\$(date +%I:%M:%S%p) $GREEN$BOLD\w$RED$BOLD\$(parse_git_branch)$GREY: "

alias l='ls -lah'
alias g='git'
alias m='make test'
alias mc='make test_client'
alias ms='make test_server'

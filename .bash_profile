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

export PS1="$BLUE\$(date +%I:%M:%S%p) $PINK(\h) $RED\w$YELLOW\$(parse_git_branch)$GREY\n» "

alias l='ls -lah'
alias g='git'
alias run='npm run-script'

#!/bin/bash
#
# Open new Terminal tabs from the command line
#
# Author: Justin Hileman (http://justinhileman.com)
#
# Installation:
#     Add the following function to your `.bashrc` or `.bash_profile`,
#     or save it somewhere (e.g. `~/.tab.bash`) and source it in `.bashrc`
#
# Usage:
#     tab                   Opens the current directory in a new tab
#     tab [PATH]            Open PATH in a new tab
#     tab [CMD]             Open a new tab and execute CMD
#     tab [PATH] [CMD] ...  You can prob'ly guess

# Only for teh Mac users
[ `uname -s` != "Darwin" ] && return

function tab () {
    local cmd=""
    local cdto="$PWD"
    local args="$@"

    if [ -d "$1" ]; then
        cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    if [ -n "$args" ]; then
        cmd="; $args"
    fi

    osascript &>/dev/null \
<<EOF
  tell application "iTerm"
    tell current terminal
      launch session "Default Session"
      tell the last session
        write text "cd \"$cdto\"$cmd"
      end tell
    end tell
  end tell
EOF
}

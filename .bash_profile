#!/bin/bash

# Various Bash-based configurations:
source ./.config/bash/colors.sh
source ./.config/bash/env.sh
source ./.config/bash/aliases.sh

# Executable files (usually functions):
source ./.bin/git_branch.sh
source ./.bin/copy.sh
source ./.bin/osx_iterm2_new_tab.sh

export PS1="$EBLUE\$(date +%I:%M:%S%p) $EPINK(\h) $ERED\w$EYELLOW\$(git_branch)$EGREY\n» "

# Get into our working directory.
cd $BASE_WORKING_DIRECTORY

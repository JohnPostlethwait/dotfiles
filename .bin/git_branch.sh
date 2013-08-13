#!/bin/bash

# Takes the git branch name from the CWD and spits it out in brackets.

function git_branch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

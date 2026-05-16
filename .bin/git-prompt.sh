#!/usr/bin/env bash
# Branch/worktree-aware git prompt with embedded ahead/behind count.
# Worktree: code-fork icon. Branch: powerline-branch icon. Both in purple.
# Ahead/behind is rendered in a magenta-leaning purple inside the brackets.
#
# Reference for ahead/behind:
#   1. upstream (@{u}) if it exists — typical case after `git push -u`
#   2. otherwise fall back to the integration branch we diverged from
#      (origin/HEAD, origin/main, origin/master, main, master — first match)
#      and prefix the count with the ref name so it's obvious which ref the
#      delta is measured against.

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git_dir=$(git rev-parse --git-dir 2>/dev/null)
case "$git_dir" in
  */worktrees/*) is_worktree=1 ;;
  *)             is_worktree=0 ;;
esac

branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
  branch=$(git rev-parse --short HEAD 2>/dev/null)
[ -z "$branch" ] && exit 0

ref_label=""
counts=$(git rev-list --left-right --count 'HEAD...@{u}' 2>/dev/null) || counts=""

if [ -z "$counts" ]; then
  # No upstream. Try to find an integration branch to compare against.
  fallback_ref=""
  if remote_head=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null); then
    fallback_ref="${remote_head#refs/remotes/}"           # e.g. origin/main
  elif git rev-parse --verify --quiet origin/main >/dev/null;   then fallback_ref="origin/main"
  elif git rev-parse --verify --quiet origin/master >/dev/null; then fallback_ref="origin/master"
  elif git rev-parse --verify --quiet main >/dev/null;          then fallback_ref="main"
  elif git rev-parse --verify --quiet master >/dev/null;        then fallback_ref="master"
  fi

  if [ -n "$fallback_ref" ] && [ "$fallback_ref" != "$branch" ]; then
    counts=$(git rev-list --left-right --count "HEAD...$fallback_ref" 2>/dev/null) || counts=""
    ref_label="${fallback_ref#origin/}"
  fi
fi

ahead=${counts%%$'\t'*}
behind=${counts##*$'\t'}
[ -z "$ahead" ]  && ahead=0
[ -z "$behind" ] && behind=0

# Glyphs as raw UTF-8 bytes — keeps PUA codepoints intact through tooling.
BRANCH_ICON=$'\xee\x82\xa0'   # U+E0A0 powerline branch
FORK_ICON=$'\xef\x84\xa6'     # U+F126 code-fork
UP_ARROW=$'\xef\x81\xa2'      # U+F062 arrow-up
DOWN_ARROW=$'\xef\x81\xa3'    # U+F063 arrow-down

if [ "$is_worktree" -eq 1 ]; then
  icon="$FORK_ICON"
else
  icon="$BRANCH_ICON"
fi
primary=$'\033[38;2;187;154;247m'    # tokyo_night purple
ahead_c=$'\033[38;2;214;112;208m'    # #d670d0 magenta-leaning purple
reset=$'\033[0m'

# When falling back to an integration branch, prefix the count with that ref's
# name so the user knows the delta isn't vs upstream.
prefix=""
[ -n "$ref_label" ] && prefix="$ref_label "

delta=""
if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
  delta=$(printf '%s(%s%s %s  %s %s)%s' \
    "$ahead_c" "$prefix" "$UP_ARROW" "$ahead" "$DOWN_ARROW" "$behind" "$primary")
elif [ "$ahead" -gt 0 ]; then
  delta=$(printf '%s(%s%s %s)%s' "$ahead_c" "$prefix" "$UP_ARROW" "$ahead" "$primary")
elif [ "$behind" -gt 0 ]; then
  delta=$(printf '%s(%s%s %s)%s' "$ahead_c" "$prefix" "$DOWN_ARROW" "$behind" "$primary")
fi

if [ -n "$delta" ]; then
  printf '%s%s [%s %s]%s' "$primary" "$icon" "$branch" "$delta" "$reset"
else
  printf '%s%s [%s]%s' "$primary" "$icon" "$branch" "$reset"
fi

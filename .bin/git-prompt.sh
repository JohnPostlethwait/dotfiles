#!/usr/bin/env bash
# Branch/worktree-aware git prompt with embedded ahead count.
# Worktree: orange + fork icon. Branch: purple + powerline-branch icon.
# Ahead count, when nonzero, is rendered yellow inside the brackets.

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git_dir=$(git rev-parse --git-dir 2>/dev/null)
case "$git_dir" in
  */worktrees/*) is_worktree=1 ;;
  *)             is_worktree=0 ;;
esac

branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
  branch=$(git rev-parse --short HEAD 2>/dev/null)
[ -z "$branch" ] && exit 0

counts=$(git rev-list --left-right --count 'HEAD...@{u}' 2>/dev/null) || counts=""
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

delta=""
if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
  delta=$(printf '%s(%s %s  %s %s)%s' \
    "$ahead_c" "$UP_ARROW" "$ahead" "$DOWN_ARROW" "$behind" "$primary")
elif [ "$ahead" -gt 0 ]; then
  delta=$(printf '%s(%s %s)%s' "$ahead_c" "$UP_ARROW" "$ahead" "$primary")
elif [ "$behind" -gt 0 ]; then
  delta=$(printf '%s(%s %s)%s' "$ahead_c" "$DOWN_ARROW" "$behind" "$primary")
fi

if [ -n "$delta" ]; then
  printf '%s%s [%s %s]%s' "$primary" "$icon" "$branch" "$delta" "$reset"
else
  printf '%s%s [%s]%s' "$primary" "$icon" "$branch" "$reset"
fi

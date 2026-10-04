# Environment-specific configuration.
BASE_WORKING_DIRECTORY="$HOME/"

# Homebrew shellenv (sets PATH, MANPATH, INFOPATH, FPATH).
eval "$(/opt/homebrew/bin/brew shellenv)"

# ls colors (BSD ls). Same as the macOS default, except world-writable dirs
# (last two pairs) are plain blue instead of black-on-green/yellow highlight.
export LSCOLORS="exfxcxdxbxegedabagexex"

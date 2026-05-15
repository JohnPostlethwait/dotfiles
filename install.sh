#!/usr/bin/env bash
# Idempotent installer: symlinks every tracked dotfile into $HOME.
# Any existing non-symlink at a destination is renamed to *.bak.<timestamp>.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP=$(date +%Y%m%d-%H%M%S)

FILES=(
  .zshrc
  .gitconfig
  .bin/copy.sh
  .bin/git-prompt.sh
  .bin/np-cache.sh
  .config/starship.toml
  .config/ghostty/config
  .config/zsh/env.zsh
  .config/zsh/aliases.zsh
  .config/zsh/colors.zsh
  .config/zsh/completions.zsh
)

link_one() {
  local rel="$1"
  local src="$REPO_DIR/$rel"
  local dst="$HOME/$rel"

  if [ ! -e "$src" ]; then
    printf '  skip  %s (missing in repo)\n' "$rel"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    printf '  ok    %s\n' "$rel"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$STAMP"
    printf '  back  %s -> %s.bak.%s\n' "$rel" "$rel" "$STAMP"
  fi

  ln -s "$src" "$dst"
  printf '  link  %s\n' "$rel"
}

echo "Installing dotfiles from $REPO_DIR -> \$HOME"
for f in "${FILES[@]}"; do
  link_one "$f"
done

cat <<EOF

Done. Open a new shell to pick up the new \$PROMPT.

Optional prereqs (Starship, fonts, music-in-prompt):
  brew install starship nowplaying-cli
  brew install --cask font-jetbrains-mono-nerd-font ghostty

You may now safely delete the macOS Ghostty config at:
  "\$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
(Ghostty prefers ~/.config/ghostty/config when it exists.)
EOF

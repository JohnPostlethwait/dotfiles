# dotfiles

My macOS shell setup. Single source of truth for `zsh`, [Starship](https://starship.rs), [Ghostty](https://ghostty.org), and a handful of small `~/.bin` helpers.

## Install

```sh
git clone https://github.com/JohnPostlethwait/dotfiles /Users/Shared/dev/dotfiles
/Users/Shared/dev/dotfiles/install.sh
```

`install.sh` is idempotent: it symlinks every tracked path into `$HOME`. Any pre-existing real file is renamed to `*.bak.<timestamp>` before the symlink is created, so it's safe to run against a live setup.

## Prereqs

```sh
brew install starship nowplaying-cli
brew install --cask font-jetbrains-mono-nerd-font ghostty
```

- **Starship** drives the prompt. The config is at [`.config/starship.toml`](.config/starship.toml).
- **nowplaying-cli** powers the music-in-prompt feature. Optional — the prompt degrades cleanly if it's missing.
- **JetBrainsMono Nerd Font** supplies the icons (folder, branch, fork, language, music note, arrows). The Ghostty config pins the font family to `JetBrainsMono Nerd Font Mono`.

## What's in here

| Path | Purpose |
| --- | --- |
| [`.zshrc`](.zshrc) | Shell entry point — sets `$PATH`, sources the `.config/zsh/*.zsh` modules, initializes Starship, configures history. |
| [`.config/zsh/env.zsh`](.config/zsh/env.zsh) | Environment variables. |
| [`.config/zsh/aliases.zsh`](.config/zsh/aliases.zsh) | Shell aliases. |
| [`.config/zsh/colors.zsh`](.config/zsh/colors.zsh) | Color helpers (legacy from the bash era; kept for any module that still references them). |
| [`.config/zsh/completions.zsh`](.config/zsh/completions.zsh) | Tab-completion setup. |
| [`.config/starship.toml`](.config/starship.toml) | Tokyo Night two-line prompt. |
| [`.config/ghostty/config`](.config/ghostty/config) | Ghostty terminal config (theme, font, padding, window behavior). |
| [`.bin/copy.sh`](.bin/copy.sh) | Tiny clipboard helper. |
| [`.bin/git-prompt.sh`](.bin/git-prompt.sh) | Renders the git segment of the prompt. Distinguishes worktrees from regular checkouts and embeds the ahead/behind counts inside the bracketed branch label. |
| [`.bin/np-cache.sh`](.bin/np-cache.sh) | Caches `nowplaying-cli` output for the prompt with paused-detection (only shows track when audio is actually advancing). |
| [`.gitconfig`](.gitconfig) | Git config. |
| [`install.sh`](install.sh) | Symlink installer. |

## Prompt features

- **Two-line layout.** Line 1: directory + git. Line 2: language version + clock + now-playing. Line 3: `❯` prompt character.
- **Worktree vs branch distinction.** Regular checkouts show a powerline-branch icon; linked worktrees show a code-fork icon — both in soft Tokyo Night purple. Detection is by `git rev-parse --git-dir` looking for `/worktrees/`.
- **Embedded ahead/behind.** Counts vs upstream live *inside* the bracketed branch label, in a magenta-leaning purple that reads as a sibling of the branch color: `[main ( N  M)]`.
- **Music when playing.** `np-cache.sh` parses `nowplaying-cli get-raw` for the elapsed-time field and only emits the track if elapsed advanced between consecutive prompts — so paused audio doesn't render. Lag is ~2 seconds in either direction (architectural, not bug — async refresh on each prompt render).
- **Language versions.** Node, Python, Rust, and Go versions show when their respective project files are present.
- **Exit status indicator.** Red `❯` on the previous command's non-zero exit; purple otherwise.
- **Command duration.** Times anything that took longer than 2 seconds.

## Tooling notes

- **Nerd Font glyphs in shell scripts** are stored as literal `$'\xXX\xXX\xXX'` ANSI-C byte sequences rather than raw UTF-8 PUA codepoints. Some tooling silently strips PUA characters when round-tripping files; the byte-escape form is bulletproof.
- **Ghostty config location** lives at the XDG path (`~/.config/ghostty/config`) rather than the macOS default (`~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`). Ghostty checks the XDG path first on macOS, so this works natively and avoids spaces in the repo tree.

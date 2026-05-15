#!/usr/bin/env bash
# Cached now-playing wrapper for the starship prompt.
#
# "Playing" is detected via macOS's coreaudiod power assertion, not via
# nowplaying-cli's ElapsedTime / PlaybackRate fields — Roon (and others) never
# update those, so the prior elapsed-delta heuristic flickered on the same
# song. coreaudiod holds an audio-out assertion while audio is actively
# flowing and releases it shortly after pause.

CACHE="/tmp/np-cache-$UID"
STALE_SECS=2

[ -r "$CACHE" ] && cat "$CACHE"

needs_refresh=1
if [ -f "$CACHE" ]; then
  age=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  [ "$age" -lt "$STALE_SECS" ] && needs_refresh=0
fi

if [ "$needs_refresh" -eq 1 ]; then
  (
    : > "$CACHE.tmp"
    if pmset -g assertions 2>/dev/null | grep -q 'coreaudiod.*preventuseridlesleep'; then
      raw=$(nowplaying-cli get-raw 2>/dev/null)
      title=$(printf  '%s' "$raw" | grep '"kMRMediaRemoteNowPlayingInfoTitle"'  | sed -E 's/.*: "(.+)".*/\1/')
      artist=$(printf '%s' "$raw" | grep '"kMRMediaRemoteNowPlayingInfoArtist"' | sed -E 's/.*: "(.+)".*/\1/')
      if [ -n "$title" ]; then
        MUSIC=$'\xef\x80\x81'  # Nerd Font U+F001 music note
        printf '%s %s — %s' "$MUSIC" "$title" "$artist" > "$CACHE.tmp"
      fi
    fi
    mv "$CACHE.tmp" "$CACHE"
  ) >/dev/null 2>&1 &
  disown 2>/dev/null
fi

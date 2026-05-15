#!/usr/bin/env bash
# Cached now-playing wrapper for starship prompt.
# Only emits track info when audio is actively playing (not paused).
# How "playing" is detected: between consecutive refreshes, elapsed time
# must have advanced. Roon doesn't update playbackRate on pause, so
# elapsed-time delta is the only reliable signal.

CACHE="/tmp/np-cache-$UID"
STATE="/tmp/np-state-$UID"
STALE_SECS=2

# Emit cached value, if any.
[ -r "$CACHE" ] && cat "$CACHE"

# Decide whether to kick off a background refresh.
needs_refresh=1
if [ -f "$CACHE" ]; then
  age=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  [ "$age" -lt "$STALE_SECS" ] && needs_refresh=0
fi

if [ "$needs_refresh" -eq 1 ]; then
  (
    raw=$(nowplaying-cli get-raw 2>/dev/null)
    title=$(printf '%s' "$raw" | grep '"kMRMediaRemoteNowPlayingInfoTitle"' | sed -E 's/.*: "(.+)".*/\1/')
    artist=$(printf '%s' "$raw" | grep '"kMRMediaRemoteNowPlayingInfoArtist"' | sed -E 's/.*: "(.+)".*/\1/')
    elapsed=$(printf '%s' "$raw" | grep '"kMRMediaRemoteNowPlayingInfoElapsedTime"' | sed -E 's/.*: ([0-9.]+).*/\1/')

    prev=""
    [ -r "$STATE" ] && prev=$(cat "$STATE")
    cur="${title}|${elapsed}"

    # Playing if: have a title, have a prior sample, AND the (title|elapsed)
    # tuple differs from it. Track change OR elapsed advancement both count.
    # First refresh has no prior, so it shows nothing — next refresh resolves.
    if [ -n "$title" ] && [ -n "$prev" ] && [ "$cur" != "$prev" ]; then
      MUSIC=$'\xef\x80\x81'  # Nerd Font U+F001 (music note)
      printf '%s %s — %s' "$MUSIC" "$title" "$artist" > "$CACHE.tmp"
    else
      : > "$CACHE.tmp"
    fi
    mv "$CACHE.tmp" "$CACHE"
    printf '%s' "$cur" > "$STATE"
  ) >/dev/null 2>&1 &
  disown 2>/dev/null
fi

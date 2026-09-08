#!/bin/bash
# pomodoro-status.sh - tab_bar_right reader, matches tmux pomodoro-plus format.
# Every branch emits exactly one line so herdr's renderer never sees a blank line.

STATE_DIR="/Users/kirubeltadesse/.local/state/herdr/plugins/herdr-pomodoro"
DISPLAY_FILE="$STATE_DIR/display"
INPUT="$(cat "$DISPLAY_FILE" 2>/dev/null)"
[ -z "$INPUT" ] && { printf '⏱︎ start?\n'; exit 0; }

PREFIX="${INPUT%%:*}"
REST="${INPUT#*: }"

print_frozen() {
  local icon="$1" progress="$2"
  local remaining="$(cat "$STATE_DIR/paused_remaining" 2>/dev/null)"
  remaining="${remaining:-0}"
  if [ -n "$progress" ]; then
    printf '%s %d:%02d %s\n' "$icon" $((remaining / 60)) $((remaining % 60)) "$progress"
  else
    printf '%s %d:%02d\n' "$icon" $((remaining / 60)) $((remaining % 60))
  fi
}

emit_time() {
  local icon="$1"
  read -r -a t <<< "$REST"
  local seg_start="${t[1]}" duration="${t[2]}" progress="${t[3]:-}"
  local now remaining mins secs
  now=$(date +%s)
  remaining=$((duration - (now - seg_start)))
  [ "$remaining" -lt 0 ] && remaining=0
  mins=$((remaining / 60))
  secs=$((remaining % 60))
  if [ -n "$progress" ]; then
    printf '%s %d:%02d %s\n' "$icon" "$mins" "$secs" "$progress"
  else
    printf '%s %d:%02d\n' "$icon" "$mins" "$secs"
  fi
}

case "$PREFIX" in
  F)
    if [ "$REST" = "start break? ▶▶" ]; then
      printf '⏲︎ break?\n'
    elif [ "${REST%% *}" = "▶" ]; then
      print_frozen "⏸︎" "$(printf '%s' "$REST" | awk '{print $4}')"
    else
      emit_time "🍅"
    fi
    ;;
  B)
    if [ "${REST%% *}" = "▶" ]; then
      print_frozen "⏸︎" ""
    else
      emit_time "✔︎"
    fi
    ;;
  *)
    printf '⏱︎ start?\n'
    ;;
esac

#!/usr/bin/env sh

# yabai executes its config file during startup before its server is ready to
# process client messages, so in-config `yabai -m` commands are dropped or hang.
# Start yabai with an empty config (nothing to execute) and apply the real
# config below once the daemon is up.

YABAI_BIN="${1:-yabai}"

PATH="$(dirname "$YABAI_BIN"):/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH

"$YABAI_BIN" -c /dev/null &

i=0
until yabai -m query --spaces > /dev/null 2>&1; do
    i=$((i + 1))
    [ "$i" -ge 100 ] && break
    sleep 0.1
done

sh "${HOME}/.config/yabai/yabairc"

wait

#!/usr/bin/env bash
# setup-herdr-plugins.sh - install herdr plugins from declarative sources.
# Idempotent: safe to run on every rebuild. Replaces existing GitHub-managed
# plugins (herdr plugin install replaces by plugin id).
set -euo pipefail

command -v herdr >/dev/null 2>&1 || { echo "herdr not found, skipping plugin setup"; exit 0; }

# Pomodoro from user's fork (has custom fixes for frozen-pause timer and
# auto-advance from focus_done to break).
herdr plugin install kirubeltadesse/herdr-pomodoro --ref main --yes

# Last workspace/tab toggle (MRU jump between the two most recent).
herdr plugin install lmilojevicc/herdr-last --ref main --yes

# Reload so keybindings and plugin actions take effect.
herdr server reload-config

#!/bin/sh
set -euo pipefail

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [coreutils mountpoint systemd]

SHARED='/mnt/shared/x'

# Normalize the requested name so "destiny 2" becomes "destiny2".
app="$(printf '%s' "$*" | tr '[:upper:]' '[:lower:]' | tr -d ' ')"

case "$app" in
  destiny2) token='destiny2' ;;
  *)
    echo "Unknown app: $*" >&2
    echo "Add it to the case list in this script." >&2
    exit 2
    ;;
esac

if ! mountpoint -q "$SHARED"; then
  echo "Shared drive isn't mounted at $SHARED" >&2
  exit 1
fi

printf '%s\n' "$token" > "$SHARED/runwin-request.txt"
systemctl start reboot-into-nt-mode.service

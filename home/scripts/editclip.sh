#!/bin/sh
set -o errexit
set -o nounset

. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [coreutils xdg-utils wl-clipboard];

PROGNAME="${0##*/}"
TMPF="${XDG_RUNTIME_DIR:-/tmp}/editclip.txt"
LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/$PROGNAME.lock"
if [ -f "$LOCKFILE" ] && kill -0 "$(cat "$LOCKFILE")" 2>/dev/null; then
    echo "$PROGNAME is already running." >&2
    return 1
fi
echo $$ >"$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT INT TERM HUP
wl-paste -n > $TMPF
chmod o-r $TMPF
neovide $TMPF && cat $TMPF | wl-copy
rm $TMPF

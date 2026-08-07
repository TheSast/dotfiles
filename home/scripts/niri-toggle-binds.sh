#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [coreutils]

BINDS_UNLOCKED_PATH="$XDG_CONFIG_HOME"/niri/binds.kdl
BINDS_UNLOCKED=false
if [ -f "$BINDS_UNLOCKED_PATH" ]; then
	BINDS_UNLOCKED=true
fi

BINDS_LOCKED_PATH="$XDG_CONFIG_HOME"/niri/binds.locked.kdl
BINDS_LOCKED=false
if [ -f "$BINDS_LOCKED_PATH" ]; then
	BINDS_LOCKED=true
fi

if "$BINDS_UNLOCKED" && ! "$BINDS_LOCKED"; then
	mv "$BINDS_UNLOCKED_PATH" "$BINDS_LOCKED_PATH"
	notify-send -a "Niri" -i state-information "Locked Keybinds" -e
fi

if ! "$BINDS_UNLOCKED" && "$BINDS_LOCKED"; then
	mv "$BINDS_LOCKED_PATH" "$BINDS_UNLOCKED_PATH"
	notify-send -a "Niri" -i state-information "Unocked Keybinds" -e
fi

if [ "$BINDS_UNLOCKED" = "$BINDS_LOCKED" ]; then
	echo "Error, binds cannot be both locked and unlocked at the same time or be undefined" 2>&1
	notify-send -a "Niri" -u critical -i state-information "Error, binds cannot be both locked and unlocked at the same time or be undefined"
fi

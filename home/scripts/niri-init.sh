#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# ++ ./log.sh.runtimeInputs
# runtimeInputs = [coreutils noctalia udiskie kanshi]
# ++ ./corn.sh.runtimeInputs;

# shellcheck source=./log.sh
. "$XDG_CONFIG_HOME/scripts/log.sh"
STATE="$XDG_STATE_HOME/niri-init"
mkdir -p "$STATE"

{
	if ! [ -f "$XDG_STATE_HOME"/noctalia/settings.toml ]; then
		mkdir -p "$XDG_STATE_HOME"/noctalia
		cp "$XDG_CONFIG_HOME"/noctalia/settings-backup/settings.toml "$XDG_STATE_HOME"/noctalia/settings.toml
	fi

	# `noctalia` which is v5, lacks various features, notably:
	# privacy-indicator plugin
	# usb-device-manager plugin
	# (global) inversion of scroll direction
	noctalia >/dev/null 2>&1 &

	udiskie --tray >/dev/null 2>&1 &

	kanshi >/dev/null 2>&1 &


	if [ "$(hostname)" = "kafka" ]; then
		hypridle >/dev/null 2>&1 &
	fi

	"$XDG_CONFIG_HOME"/scripts/corn.sh --startup >/dev/null 2>&1 &
} | log niri-init.sh >>"$STATE/niri-init.log" 2>&1

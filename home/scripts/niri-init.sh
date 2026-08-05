#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [coreutils systemd noctalia udiskie kanshi kdeconnectd steam]
# ++ ./corn.sh.runtimeInputs;

run() {
	UNIT_NAME="$1"
	if [ -f "$UNIT_NAME" ]; then
		UNIT_NAME=$(basename "$UNIT_NAME")
	fi
	systemd-run --user \
		--unit="$UNIT_NAME"-transient \
		--property=Restart=on-failure \
		--property=RestartSec=2 \
		--property=PartOf=niri.service \
		--property=BindsTo=niri.service \
		"$@"
}

if [ -f "$XDG_STATE_HOME"/noctalia/settings.toml ]; then
	cp "$XDG_STATE_HOME"/noctalia/settings.toml "$XDG_CONFIG_HOME"/etc/home/noctalia/settings-backup/"$(hostname)".toml
else
	mkdir -p "$XDG_STATE_HOME"/noctalia
	cp "$XDG_CONFIG_HOME"/noctalia/settings-backup/"$(hostname)".toml "$XDG_STATE_HOME"/noctalia/settings.toml
fi
# TODO: also apply to plugin config data

rm "$XDG_CACHE_HOME"/tofi-drun -f

# `noctalia` which is v5, lacks various features, notably:
# privacy-indicator plugin
# usb-device-manager plugin
# (global) inversion of scroll direction
run noctalia &

run udiskie --tray &

if [ "$(hostname)" = "kafka" ]; then
	run kanshi &

	run kdeconnectd &
fi

if [ "$(hostname)" = "firefly" ]; then
	run steam -nochatui -nofriendsui -silent &
fi

run "$XDG_CONFIG_HOME"/scripts/corn.sh --startup

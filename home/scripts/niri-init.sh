#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [coreutils systemd noctalia udiskie kanshi]
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

if ! [ -f "$XDG_STATE_HOME"/noctalia/settings.toml ]; then
	mkdir -p "$XDG_STATE_HOME"/noctalia
	cp "$XDG_CONFIG_HOME"/noctalia/settings-backup/settings.toml "$XDG_STATE_HOME"/noctalia/settings.toml
fi

# `noctalia` which is v5, lacks various features, notably:
# privacy-indicator plugin
# usb-device-manager plugin
# (global) inversion of scroll direction
run noctalia &

run udiskie --tray &

run kanshi &


run "$XDG_CONFIG_HOME"/scripts/corn.sh --startup

#!/bin/sh
set -o errexit
set -o nounset

. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [coreutils];

log() {
	DATE="date +%Y-%m-%dT%H:%M:%S,%N"
	if [ -t 0 ]; then
		echo "$($DATE)" "$@"
	else
		while read -r line; do
			echo "$($DATE)" "$@" "$line"
		done
	fi
}

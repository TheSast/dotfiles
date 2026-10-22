#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [ coreutils gnugrep procps ] ++ ./variate-rice.sh.runtimeInputs ++ ./init-rice.sh.runtimeInputs;

PROGNAME="${0##*/}"
STATE="$XDG_STATE_HOME/corn"
mkdir -p "$STATE"

# log(msg: String) -> ()
log() {
	echo "$(date +%Y-%m-%dT%H:%M:%S,%N)" "$@" >>"$STATE/corn.log" 2>&1
}

# log_cmd(cmd: String, ... @ args: [String]) -> ()
log_cmd() {
	log "START" "$1"
	"$@" >>"$STATE/corn.log" 2>&1 || log "unwrap: " "$@"
	log "END" "$1"
}

# scheduled() -> u64
scheduled() {
	NOW="$(date +%s)"
	if [ "$NOW" -ge "$(date +%s --date=18)" ]; then
		SCHEDULED="$(date +%s --date=18)"
	else
		if [ "$NOW" -ge "$(date +%s --date=6)" ]; then
			SCHEDULED="$(date +%s --date=6)"
		else
			SCHEDULED="$(date +%s --date='yesterday 18')"
		fi
	fi
	echo "$SCHEDULED"
}

# shellcheck disable=SC2120
# variate_rice(... @ args: [String]) -> ()
variate_rice() {
	log_cmd "$XDG_CONFIG_HOME/scripts/variate-rice.sh" "$@"
	NOW="$(date +%s)"
	echo "$NOW" >"$STATE/variate-rice.time"
}

# init_rice() -> ()
init_rice() {
	log_cmd "$XDG_CONFIG_HOME/scripts/init-rice.sh"
}

## check every 1s
## if it's day or night and change the theming accordingly and if it
## is not the time yet but the device just booted up then just pick up
## from how the theming was last time
# main() -> !
main() {
	SYSTEM_STARTUP=false
	if [ "${1-}" = "--startup" ]; then
		SYSTEM_STARTUP=true
	fi

	CURRENT_PID="$$"
	# bash creates a `pgrep` detectable subprocess when there is a pipe or an AND/OR therefore disable errexit instead of adding `|| true`
	set +o errexit
	RUNNING_INSTANCES="$(pgrep -x "$PROGNAME")"
	set -o errexit
	OTHER_RUNNING_INSTANCES="$(echo "$RUNNING_INSTANCES" | grep -v "$CURRENT_PID" || true)"

	if [ "$OTHER_RUNNING_INSTANCES" != "" ]; then
		log "attempted to run $PROGNAME $CURRENT_PID while $OTHER_RUNNING_INSTANCES was running"
		echo "check $STATE/corn.log"
		exit 1
	fi
	log "$PROGNAME START PID: $CURRENT_PID"

	while true; do
		if ! [ -f "$STATE/variate-rice.time" ]; then
			date --date=@0 +%s >"$STATE/variate-rice.time"
			log "no valid variate-rice.time found"
		fi
		LASTRUN="$(cat "$STATE"/variate-rice.time || log "expect: failed condition check before running cat on stored time")"
		if [ "$LASTRUN" -le "$(scheduled)" ]; then
			variate_rice #()
		else
			if "$SYSTEM_STARTUP"; then
				init_rice #()
			fi
		fi
		SYSTEM_STARTUP=false
		sleep 1 || log "expect: sleep killed"
	done
}
main "$@"

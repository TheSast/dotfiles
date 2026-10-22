#!/bin/sh

# expects proper XDG base dirs variables to be set up
. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [coreutils gnugrep /* linux utils? */ ]

USAGE="Usage: ${0##*/}"
[ -n "$1" ] && echo "$USAGE"

fail() { echo ${0##*/}: 1>&2 "$*"; exit 1; }

# is hibernation supported
grep -q disk /sys/power/state || fail "hibernate not supported"

# do we have permissions to hibernate (doesn't check readonlyfs)
test -w /sys/power/state || fail "sleep permission denied"

(
flock -n 9 || fail "another instance is running"

printf "Zzzz... "

# FIXME: systemd hooks are not properly run

# for hook in /etc/zzz.d/suspend/*; do
#   [ -x "$hook" ] && "$hook"
# done

# systemctl start hibernate.target # running this would hibernate when I want to hibernate and reboot
echo reboot >/sys/power/disk
printf disk >/sys/power/state || fail "hibernate failed"

# for hook in /etc/zzz.d/resume/*; do
#   [ -x "$hook" ] && "$hook"
# done

echo "yawn."
) 9</sys/power

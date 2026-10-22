#!/bin/sh

# expects proper XDG base dirs variables to be set up
. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [coreutils gnugrep efibootmgr /* linux utils? */ ] ++ ./hibernate-reboot.sh.runtimeInputs

USAGE="Usage: ${0##*/} <OS>"
[ -z "$1" ] && echo "$USAGE" && exit 1

fail() { echo ${0##*/}: 1>&2 "$*"; exit 1; }

NEXT_BOOT="$(efibootmgr | grep -i "$1" -m 1 | grep -E "[0-9]{4}" -o | head -n 1 || fail "$1 boot not found")" 
efibootmgr --bootnext "$NEXT_BOOT" -q || fail "$1 bootnext failed"
# "$XDG_CONFIG_HOME/scripts/hibernate-reboot.sh"
# /home/u/.config/scripts/hibernate-reboot.sh # FIXME: xdg variables are not kept :(

#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [coreutils noctalia]
# ++ ./log.sh.runtimeInputs
# ++ ./theme.sh.runtimeInputs;

# shellcheck source=./log.sh
. "$XDG_CONFIG_HOME/scripts/log.sh"
THEME=$("$XDG_CONFIG_HOME/scripts/theme.sh")
export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

# NOTE: this is only necessary because only one of the noctalia implementations is active at one time
{
	echo "START"
	noctalia msg wallpaper-set "$XDG_CACHE_HOME/wallpaper" || true
  noctalia msg theme-mode-set $THEME || true
	echo "END"
} 2>&1 | log noctalia &

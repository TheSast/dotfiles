#!/bin/sh
set -o errexit
set -o nounset

. "$XDG_CONFIG_HOME/script.path"
# runtimeInputs = [coreutils]
# NOTE: Neovim handles this via lua
if [ "$(date +%H)" -ge 18 ] || [ "$(date +%H)" -lt 06 ]; then
    THEME="dark"
else
    THEME="light"
fi

echo "$THEME"

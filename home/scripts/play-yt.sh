#!/bin/sh

. "$XDG_CONFIG_HOME/script.path"
"$(xdg-mime query default video/mp4 | sed 's/\.desktop$//')" "$@"

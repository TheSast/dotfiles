#!/bin/sh
set -o errexit
set -o nounset

# expects proper XDG base dirs variables to be set up
# runtimeInputs = [findutils coreutils noctalia glib gsettings-desktop-schemas]
# ++ ./log.sh.runtimeInputs
# ++ ./theme.sh.runtimeInputs;

# shellcheck source=./log.sh
. "$XDG_CONFIG_HOME/scripts/log.sh"
THEME=$("$XDG_CONFIG_HOME/scripts/theme.sh")
export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

{
	echo "START"
	WALLPAPER_DIR="$XDG_PICTURES_DIR/wallpapers"
	find_wallpaper() {
		find "$WALLPAPER_DIR" -type f -path "*/$THEME/*" -not -path "*/.*" | shuf -n 1
	}
	WALLPAPER="$(find_wallpaper)"
	echo "$WALLPAPER"
	ln -sf "$WALLPAPER" "$XDG_CACHE_HOME/wallpaper"
	echo "END"
} 2>&1 | log wallpaper

{
	echo "START"
	noctalia msg wallpaper-set $(realpath "$XDG_CACHE_HOME/wallpaper") || true
  noctalia msg theme-mode-set $THEME || true
	echo "END"
} 2>&1 | log noctalia &

{
	echo "START"
	GTK_THEME="adw-gtk3"
	COLORSCHEME="prefer-light"
	if [ "$THEME" = "dark" ]; then
		GTK_THEME="adw-gtk3-dark"
		COLORSCHEME="prefer-dark"
	fi
	gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
	gsettings set org.gnome.desktop.interface color-scheme $COLORSCHEME
	echo "END"
} 2>&1 | log gsettings &

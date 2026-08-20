#!/bin/bash

HYPRPAPER=$HOME/.config/hypr/hyprpaper.conf

WALLPAPERS=("dark" "light")
WALLPAPER_FILE=$HOME/.cache/current_wallpaper

get_current_wallpaper() {
	if [ -f "$WALLPAPER_FILE" ]; then
		cat "$WALLPAPER_FILE"
	else
		echo "dark"
	fi
}

set_wallpaper() {
	local wallpaper=$1
	echo "$wallpaper" > "$WALLPAPER_FILE"
}

apply_wallpaper_block() {
	local file=$1
	local tag=$2
	local wallpaper=$3

    local open="#"
    local close=""
    local pattern_comment="s|^\([^#]\)|#\1|"
    local pattern_uncomment="s|^#\(.*$tag:$theme\)|\1|"

	sed -i "/$tag:/{ $pattern_comment }" "$file"
	sed -i "/$tag:$wallpaper/{ $pattern_uncomment }" "$file"
}

apply_dark() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "dark" "hash"
	pkill hyprpaper 
    hyprpaper &
}

apply_light() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "light" "hash"
	pkill hyprpaper 
    hyprpaper &
}

toggle_wallpaper() {
	local current=$(get_current_wallpaper)

	if [ "$current" = "dark" ]; then
		apply_light
		set_wallpaper "light"
	else
		apply_dark
		set_wallpaper "dark"
	fi
}

toggle_wallpaper

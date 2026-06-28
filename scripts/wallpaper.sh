#!/bin/bash

HYPRPAPER=$HOME/.config/hypr/hyprpaper.conf

WALLPAPERS=("wave" "centiped" "eyes" "shinji")
WALLPAPER_FILE=$HOME/.cache/current_wallpaper

get_current_wallpaper() {
	if [ -f "$WALLPAPER_FILE" ]; then
		cat "$WALLPAPER_FILE"
	else
		echo "wave"
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

apply_wave() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "wave" "hash"
	pkill hyprpaper 
    hyprpaper &
}

apply_centiped() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "centiped" "hash"
	pkill hyprpaper 
    hyprpaper &
}

apply_eyes() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "eyes" "hash"
	pkill hyprpaper 
    hyprpaper &
}

apply_shinji() {
	apply_wallpaper_block "$HYPRPAPER" "wallpaper" "shinji" "hash"
	pkill hyprpaper 
    hyprpaper &
}

toggle_wallpaper() {
	local current=$(get_current_wallpaper)

	if [ "$current" = "wave" ]; then
		apply_centiped
		set_wallpaper "centiped"
	elif [ "$current" = "centiped" ]; then
		apply_eyes
		set_wallpaper "eyes"
	elif [ "$current" = "eyes" ]; then
		apply_shinji
		set_wallpaper "shinji"
	else
		apply_wave
		set_wallpaper "wave"
	fi
}

toggle_wallpaper

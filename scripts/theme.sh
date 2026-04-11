#! /bin/bash

# config files
HYPRPAPER=$HOME/.config/hypr/hyprpaper.conf
NVIM=$HOME/.config/nvim/init.lua
WAYBAR=$HOME/.config/waybar/style.css

# available themes
THEMES=("lain", "gruvbox", "cats")
THEME_FILE=$HOME/.cache/current_theme

# functions
get_current_theme() {
	if [ -f "$THEME_FILE" ]; then
		cat "$THEME_FILE"
	else
		echo "cats"
	fi
}

set_theme() {
	local theme=$1
	echo "$theme" > "$THEME_FILE"
}

apply_theme_block() {
	local file=$1
	local tag=$2
	local theme=$3
	local comment_style=$4

	case "$comment_style" in
		hash) 
			local open="#"
			local close=""
			local pattern_comment="s|^\([^#]\)|#\1|"
            local pattern_uncomment="s|^#\(.*$tag:$theme\)|\1|"
		;;
		slash)
			local open="/*"
            local close="*/"
            local pattern_comment="s|^\([^*]*\)\( /\*$tag:\)|\/\*\1*\/\2|"
    		local pattern_uncomment="s|^/\*\(.*\)\*/ \(/\*$tag:$theme\)|\1 \2|"
		;;
		dash)
			local open="--"
            local close=""
            local pattern_comment="s|^\([^-]\)|--\1|"
            local pattern_uncomment="s|^--\(.*$tag:$theme\)|\1|"
		;;
	esac
	

	sed -i "/$tag:/{ $pattern_comment }" "$file"
	sed -i "/$tag:$theme/{ $pattern_uncomment }" "$file"
}

apply_lain() {
	apply_theme_block "$HYPRPAPER" "theme" "lain" "hash"
	apply_theme_block "$WAYBAR" "theme" "lain" "slash"
	apply_theme_block "$NVIM" "theme" "lain" "dash"

	pkill hyprpaper && hyprpaper &
	pkill waybar && waybar &
}

apply_gruvbox() {
	apply_theme_block "$HYPRPAPER" "theme" "gruvbox" "hash"
	apply_theme_block "$WAYBAR" "theme" "gruvbox" "slash"
	apply_theme_block "$NVIM" "theme" "gruvbox" "dash"

	pkill hyprpaper && hyprpaper &
	pkill waybar && waybar
}

apply_cats() {
	apply_theme_block "$HYPRPAPER" "theme" "cats" "hash"
	apply_theme_block "$WAYBAR" "theme" "cats" "slash"
	apply_theme_block "$NVIM" "theme" "cats" "dash"

	pkill hyprpaper && hyprpaper &
	pkill waybar && waybar &
}

toggle_theme() {
	local current=$(get_current_theme)

	if [ "$current" = "lain" ]; then
		apply_gruvbox
		set_theme "gruvbox"
	elif [ "$current" = "cats" ]; then
		apply_lain
		set_theme "lain"
	else
		apply_cats
		set_theme "cats"
	fi
}

# execution
toggle_theme

#!/bin/bash

WALL_CONF="~/.config/hypr/hyprpaper.conf"
WALL_DIR="$HOME/dotfiles/wallpapers"
WALL_LIST=("$WALL_DIR"/*)
INTERVAL=360

# evita múltiplas instâncias
exec 9>"/tmp/dwall.lock"
flock -n 9 || exit 0

i=0
while true; do
    PAPER="${WALL_LIST[$i]}"
    sed -i -E "s|wallpapers/.*|wallpapers/$PAPER|g" "$WALL_CONF"
    pkill hyprpaper
    hyprpaper &

    i=$(( (i + 1) % ${#WALL_LIST[@]} ))
    sleep "$INTERVAL"
done

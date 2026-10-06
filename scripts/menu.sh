#!/bin/bash

WALL_CONF="$HOME/.config/hypr/hyprpaper.conf"
WALL_DIR="$HOME/dotfiles/wallpapers"

BEMENU_OPTS=(-i -c -l 5 -W 0.2 -p ">" -H 23
    --tb "#000000" --tf "#ffffff"
    --fb "#000000" --ff "#ffffff"
    --cb "#000000" --cf "#ffffff"
    --nb "#000000" --nf "#777777"
    --hb "#000000" --hf "#ffffff"
    --fbb "#000000" --fbf "#777777"
    --sb "#000000" --sf "#ffffff"
    --ab "#000000" --af "#777777"
    --scb "#000000" --scf "#ffffff")

menu() { bemenu "${BEMENU_OPTS[@]}"; }

case $1 in
    app)
        j4-dmenu-desktop --dmenu="bemenu ${BEMENU_OPTS[*]@Q}"
        ;;
    sys)
        case "$(printf '%s\n' shutdown reboot logout lock | menu)" in
            shutdown) shutdown now ;;
            reboot)   shutdown -r now ;;
            logout)   loginctl terminate-user "$USER" ;;
            lock)     hyprlock ;;
            *)        exit 1 ;;
        esac
        ;;
    wall)
        paper=$(find "$WALL_DIR" -maxdepth 1 -type f -printf '%f\n' | sort | menu)
        [ -z "$paper" ] && exit 1
        sed -i -E "s|wallpapers/.*|wallpapers/$paper|g" "$WALL_CONF"
        pkill hyprpaper
        setsid hyprpaper >/dev/null 2>&1 &
        ;;
esac

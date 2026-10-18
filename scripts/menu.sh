#!/bin/bash

WALL_CONF="$HOME/.config/hypr/hyprpaper.conf"
WALL_DIR="$HOME/dotfiles/wallpapers"

BEMENU_OPTS=(-i -c -l 5 -W 0.2 -p ">" -H 23
    --fn "Hack Nerd Font 10"
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
    proc)
        n=$(nproc)
        sel=$(LC_ALL=C top -bn2 -d 0.5 -w 512 | awk -v n="$n" '
            /^top -/ {iter++}
            iter==2 && $1 ~ /^[0-9]+$/ && $12 != "top" {c[$12] += $9 / n}
            END {for (k in c) printf "%5.1f%%  %s\n", c[k], k}' \
            | sort -rn | head -n 10 | menu)
        [ -z "$sel" ] && exit 1
        name=$(awk '{print $2}' <<< "$sel")
        pkill -x "$name"
        ;;
esac

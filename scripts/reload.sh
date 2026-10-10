#!/bin/bash

if [ music=$(pgrep -f ~/dotfiles/scripts/music-monitor.sh) ]; then
    kill $music
fi

killall qs
killall hyprpaper
killall dunst

qs &
hyprpaper &
dunst &
~/dotfiles/scripts/music-monitor.sh &

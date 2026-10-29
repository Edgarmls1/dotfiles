#!/bin/bash

DP_CONNECTED=$(hyprctl monitors | grep -c "DP-1")

if [ "$1" = "disable" ]; then
    hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = true })"
elif [ "$1" = "enable" ]; then
    hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = false, mode = '1920x1080@60', position = '-1921x0', scale = 1 })" # position = '0x1081', scale = 1 transform = 2
# else
#     if [ $DP_CONNECTED -eq 0 ]; then
#         hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = false, mode = '1920x1080@60', position = '0x0', scale = 1, transform = 1 })"
#     fi
fi

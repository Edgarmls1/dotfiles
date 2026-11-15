#!/bin/bash

if [ "$1" = "disable" ]; then
    hyprctl eval "hl.monitor({ output = 'HDMI-A-2', disabled = true })" # HDMI
elif [ "$1" = "enable" ]; then
    hyprctl eval "hl.monitor({ output = 'HDMI-A-2', disabled = false, mode = '1920x1200@60', position = '0x1080', scale = 1 })"
fi

#!/bin/bash

HDMI_CONNECTED=$(hyprctl monitors | grep -c "HDMI-A-2")
DP_CONNECTED=$(hyprctl monitors | grep -c "DP-1")

if [ $HDMI_CONNECTED -gt 0 ] && [ $DP_CONNECTED -gt 0 ]; then
	hyprctl dispatch "hl.monitor({ output = 'eDP-1', disabled = true })"
	hyprctl dispatch "hl.monitor({ output = 'HDMI-A-2', mode = '1920x1080', position = '0x0', scale = '1', })"
	hyprctl dispatch "hl.monitor({ output = 'DP-1', mode = '1920x1080', position = '0x1080', scale = '1', })"
elif [ $HDMI_CONNECTED -eq 0 ] && [ $DP_CONNECTED -gt 0 ]; then
	hyprctl dispatch "hl.monitor({ output = 'eDP-1', mode = '1920x1080', position = '0x0', scale = '1', })"
	hyprctl dispatch "hl.monitor({ output = 'HDMI-A-2', mode = disabled = true })"
	hyprctl dispatch "hl.monitor({ output = 'DP-1', mode = '1920x1080', position = '1920x0', scale = '1', })"
elif [ $HDMI_CONNECTED -gt 0 ] && [ $DP_CONNECTED -eq 0 ]; then
	hyprctl dispatch "hl.monitor({ output = 'eDP-1', '1920x1080', position = '0x0', scale = '1', })"
	hyprctl dispatch "hl.monitor({ output = 'HDMI-A-2', mode = '1920x1080', position = '1920x0', scale = '1', })"
	hyprctl dispatch "hl.monitor({ output = 'DP-1', disabled = true })"
else
	hyprctl dispatch "hl.monitor({ output = 'eDP-1', mode = '1920x1080', position = '0x0', scale = '1', })"
	hyprctl dispatch "hl.monitor({ output = 'HDMI-A-2', disabled = true })"
	hyprctl dispatch "hl.monitor({ output = 'DP-1', disabled = true })"
fi

pkill waybar && waybar &

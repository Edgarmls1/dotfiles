#!/bin/bash

HDMI_CONNECTED=$(hyprctl monitors | grep -c "HDMI-A-2")
DP_CONNECTED=$(hyprctl monitors | grep -c "DP-1")

if [ $HDMI_CONNECTED -gt 0 ] && [ $DP_CONNECTED -gt 0 ]; then
	hyprctl keyword monitor "eDP-1,disable"
	hyprctl keyword monitor "HDMI-A-2,1920x1080@144,0x0,1"
	hyprctl keyword monitor "DP-1,1366x768@59,0x1080,1"
elif [ $HDMI_CONNECTED -eq 0 ] && [ $DP_CONNECTED -gt 0 ]; then
	hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1"
	hyprctl keyword monitor "HDMI-A-2,disable"
	hyprctl keyword monitor "DP-1,1366x768@59,0x1080,1"
elif [ $HDMI_CONNECTED -gt 0 ] && [ $DP_CONNECTED -eq 0 ]; then
	hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1"
	hyprctl keyword monitor "HDMI-A-2,1920x1080@144,1920x0,1"
	hyprctl keyword monitor "DP-1,disable"
else
	hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1"
	hyprctl keyword monitor "HDMI-A-2,disable"
	hyprctl keyword monitor "DP-1,disable"
fi

killall waybar
waybar &

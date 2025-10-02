#! /bin/bash

chosen=$(printf "Power Off\nRestart\nLock" | rofi -dmenu -i -p "" -theme "~/.config/rofi/power.rasi")

case "$chosen" in 
	"Power Off") systemctl poweroff ;;
	"Restart") systemctl reboot     ;;
	"Lock") hyprlock                ;;
	*) exit 1                       ;;
esac

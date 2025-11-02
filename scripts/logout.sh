#! /bin/bash

chosen=$(printf "Hibernate\nPower Off\nRestart" | rofi -dmenu -i -p "" -theme "~/.config/rofi/power.rasi")

case "$chosen" in 
	"Power Off") systemctl poweroff     ;;
	"Restart") systemctl reboot         ;;
	"Hibernate") systemctl hybrid-sleep ;;
	*) exit 1                           ;;
esac

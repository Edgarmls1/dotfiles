#!/bin/bash
if playerctl -p spotify status &>/dev/null; then
    status=$(playerctl -p spotify status)
    info=$(playerctl -p spotify metadata --format '{{artist}} - {{title}}')
    icon=$([[ "$status" == "Playing" ]] && echo "" || echo "")
    echo " $info"
else
    echo ""
fi

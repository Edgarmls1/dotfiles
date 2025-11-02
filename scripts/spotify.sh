#!/bin/bash
if playerctl -p spotify status &> /dev/null; then
    status=$(playerctl -p spotify status)
	artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)
    if [ "$status" = "Playing" ]; then
        echo " $artist - $title"
	else
		echo " $artist - $title"
    fi
else
	echo ""
fi

case $BLOCK_BUTTON in
	5 ) playerctl -p spotify previous   ;;
	1 ) playerctl -p spotify play-pause ;;
	4 ) playerctl -p spotify next       ;;
esac
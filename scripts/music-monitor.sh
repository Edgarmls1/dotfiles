#!/bin/bash

notification_timeout=5000
download_album_art=true
show_album_art=true

function get_album_art {
    url=$(playerctl -p spotify -f "{{mpris:artUrl}}" metadata)

    if [[ $url == "file://"* ]]; then
        album_art="${url/file:\/\//}"
    elif [[ $url == "http://"* || $url == "https://"* ]]; then
        filename="$(basename "$url" | sed 's/?.*//')"
        if [ ! -f "/tmp/$filename" ]; then
            wget -q -O "/tmp/$filename" "$url"
        fi
        album_art="/tmp/$filename"
    else
        album_art=""
    fi
}

function show_music_notif {
    song_title=$(playerctl -p spotify -f "{{title}}" metadata)
    song_artist=$(playerctl -p spotify -f "{{artist}}" metadata)

    if [[ $show_album_art == "true" ]]; then
        get_album_art
    fi

    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title - $song_artist" 
}

function monitor_loop {
    while IFS="|||" read -r title artist; do
        get_album_art
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:music_notif \
            -i "$album_art" \
            "$title - $artist"
    done < <(playerctl --player=spotify --follow metadata --format "{{title}}|{{artist}}")
}

case $1 in
	next_track)
		playerctl -p spotify next
		sleep 0.5 && show_music_notif
	;;

	prev_track)
		playerctl -p spotify previous
		sleep 0.5 && show_music_notif
	;;

    play_pause)
	    playerctl -p spotify play-pause
    	show_music_notif
    ;;

	*)
		monitor_loop
	;;
esac

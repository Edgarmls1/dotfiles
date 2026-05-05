#!/bin/bash

notification_timeout=10000
download_album_art=true

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

	get_album_art

    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title - $song_artist" 
}

while true; do
    show_music_notif
done

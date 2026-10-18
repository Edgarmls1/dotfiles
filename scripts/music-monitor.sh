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

# Escapa caracteres que quebrariam o markup (ex: "Simon & Garfunkel")
function escape_markup {
    local s=$1
    s=${s//&/&amp;}
    s=${s//</&lt;}
    s=${s//>/&gt;}
    printf '%s' "$s"
}

function send_notif {
    local title=$1 artist=$2
    album_art=""

    if [[ $show_album_art == "true" ]]; then
        get_album_art
    fi

    notify-send -t "$notification_timeout" \
        -h string:x-dunst-stack-tag:music_notif \
        -i "$album_art" \
        "$(escape_markup "$title")" \
        "<small>$(escape_markup "$artist")</small>"
}

function show_music_notif {
    local song_title song_artist
    song_title=$(playerctl -p spotify -f "{{title}}" metadata)
    song_artist=$(playerctl -p spotify -f "{{artist}}" metadata)
    send_notif "$song_title" "$song_artist"
}

function monitor_loop {
    while IFS="|" read -r title artist; do
        send_notif "$title" "$artist"
    done < <(playerctl --player=spotify --follow metadata --format "{{title}}|{{artist}}")
}

case $1 in
    next)
        playerctl -p spotify next
        sleep 0.5 && show_music_notif
    ;;

    prev)
        playerctl -p spotify previous
        sleep 0.5 && show_music_notif
    ;;

    play)
        playerctl -p spotify play-pause
        show_music_notif
    ;;

    *)
        monitor_loop
    ;;
esac

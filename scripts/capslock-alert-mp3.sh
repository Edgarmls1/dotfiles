#!/usr/bin/env bash

set -euo pipefail

MP3_PADRAO="$HOME/dotfiles/sounds/caps.mp3"
MP3="${1:-$MP3_PADRAO}"

if [[ ! -f "$MP3" ]]; then
    exit 0
fi

LED_PATH=$(find /sys/class/leds -maxdepth 1 -iname "*capslock*" | head -n1)

if [[ -z "$LED_PATH" ]]; then
    exit 0
fi

ESTADO=$(cat "$LED_PATH/brightness")

if [[ "$ESTADO" -ne 0 ]]; then
    if command -v mpv &>/dev/null; then
        mpv --no-video --really-quiet "$MP3" &
    elif command -v ffplay &>/dev/null; then
        ffplay -nodisp -autoexit -loglevel quiet "$MP3" &
    elif command -v mpg123 &>/dev/null; then
        mpg123 -q "$MP3" &
    fi
fi

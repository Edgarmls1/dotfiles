#!/bin/bash

set -uo pipefail

weather_icon() {
    local weather_data weather_code sunrise sunset
    local now_epoch sunrise_epoch sunset_epoch night icon

    weather_data=$(curl -fsS --max-time 3 "https://wttr.in?format=j1" 2>/dev/null \
        | jq -er '[.current_condition[0].weatherCode, .weather[0].astronomy[0].sunrise, .weather[0].astronomy[0].sunset] | select(all(. != null and . != "")) | @tsv' 2>/dev/null) || return 1

    IFS=$'\t' read -r weather_code sunrise sunset <<< "$weather_data"

    if [[ ! $weather_code =~ ^[0-9]+$ || ! $sunrise =~ ^[0-9]{1,2}:[0-9]{2}\ [AP]M$ || ! $sunset =~ ^[0-9]{1,2}:[0-9]{2}\ [AP]M$ ]]; then
        return 1
    fi

    now_epoch=$(date +%s)
    sunrise_epoch=$(date -d "today $sunrise" +%s 2>/dev/null || echo 0)
    sunset_epoch=$(date -d "today $sunset" +%s 2>/dev/null || echo 0)

    if (( sunrise_epoch > 0 && sunset_epoch > 0 && (now_epoch < sunrise_epoch || now_epoch >= sunset_epoch) )); then
        night=true
    else
        night=false
    fi

    case $weather_code in
        113) [[ $night == "true" ]] && icon="" || icon="" ;;
        116) [[ $night == "true" ]] && icon="" || icon="" ;;
        119|122) icon="" ;;
        143|248|260) icon="" ;;
        176|263|353) [[ $night == "true" ]] && icon="" || icon="" ;;
        179|227|230|323|326|368) [[ $night == "true" ]] && icon="" || icon="" ;;
        182|185|281|284|311|314|317|320|350|362|365|374|377) icon="" ;;
        200|386|389|392|395) icon="" ;;
        266|293|296|299|302|305|308|356|359) icon="" ;;
        329|332|335|338|371) icon="" ;;
        *) icon="" ;;
    esac

    printf '%s' "$icon"
}

weather_text() {
    curl -fsS --max-time 3 "wttr.in?format=%C+%t+(%f)+%h+%w" 2>/dev/null
}

weather_status() {
    local icon text

    icon=$(weather_icon) || icon=""
    text=$(weather_text) || text="Indisponível"

    if [[ -n $icon ]]; then
        printf '%s  %s\n' "$icon" "$text"
    else
        printf '%s\n' "$text"
    fi
}

weather_notify() {
    local icon text title body

    icon=$(weather_icon) || icon=""
    text=$(weather_text) || text="Não foi possível obter o clima"

    title="${icon:-󰖐} Weather"
    body="$text"

    notify-send -i weather "$title" "$body"
}

main() {
    local cmd="${1:-status}"

    case "$cmd" in
        icon)
            weather_icon
            echo
            ;;
        text)
            weather_text
            echo
            ;;
        status)
            weather_status
            ;;
        notify)
            weather_notify
            ;;
        *)
            echo "Uso: $0 {icon|text|status|notify}" >&2
            exit 1
            ;;
    esac
}

main "$@"

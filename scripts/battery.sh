#!/bin/bash

set -euo pipefail

get_battery_info() {
  upower -i "$(upower -e | grep BAT)"
}

battery_capacity() {
  get_battery_info | awk '/energy-full:/ {
      printf "%d", $2
      exit
  }'
}

battery_present() {
  for bat in /sys/class/power_supply/BAT*; do
    [[ -r $bat/present ]] &&
    [[ $(cat "$bat/present") == "1" ]] &&
    [[ $(cat "$bat/type") == "Battery" ]] &&
    return 0
  done

  return 1
}

battery_remaining() {
  get_battery_info | awk '/percentage/ {
      print int($2)
      exit
  }'
}

battery_remaining_time() {
  get_battery_info | awk '/time to (empty|full)/ {
      value = $4
      unit = $5
      if (unit ~ /^minute/) {
          printf "%dm", int(value)
      } else {
          hours = int(value)
          minutes = int((value - hours) * 60)
          if (minutes > 0) {
              printf "%dh %dm", hours, minutes
          } else {
              printf "%dh", hours
          }
      }
      exit
  }'
}

battery_status() {
  local battery_info percentage power_rate state time_remaining capacity
 
  battery_info=$(get_battery_info)
 
  percentage=$(echo "$battery_info" | awk '/percentage/ {
      print int($2)
      exit
  }')
 
  power_rate=$(echo "$battery_info" | awk '/energy-rate/ {
      rounded = sprintf("%.1f", $2)
      sub(/\.0$/, "", rounded)
      print rounded
      exit
  }')
 
  state=$(echo "$battery_info" | awk '/state/ { print $2; exit }')
  time_remaining=$(battery_remaining_time)
  capacity=$(battery_capacity)
 
  if [[ $state == "charging" ]]; then
      echo "Battery ${percentage}%  ·  ${time_remaining} to full  ·   ${power_rate}W / ${capacity}Wh"
  else
      echo "Battery ${percentage}%  ·  ${time_remaining} left  ·   ${power_rate}W / ${capacity}Wh"
  fi
}

battery_monitor() {
  local BATTERY_THRESHOLD=10
  local NOTIFICATION_FLAG="/run/user/$UID/battery_notified"
  local BATTERY_LEVEL BATTERY_STATE

  BATTERY_LEVEL=$(battery_remaining)
  BATTERY_STATE=$(get_battery_info | grep -E "state" | awk '{print $2}')

  send_notification() {
    notify-send -u critical "󱐋 Time to recharge!" "Battery is down to ${1}%" -i battery-caution -t 30000
    omarchy-hook battery-low "$1"
  }

  if [[ -n $BATTERY_LEVEL && $BATTERY_LEVEL =~ ^[0-9]+$ ]]; then
    if [[ $BATTERY_STATE == "discharging" ]] && (( BATTERY_LEVEL <= BATTERY_THRESHOLD )); then
      if [[ ! -f $NOTIFICATION_FLAG ]]; then
        send_notification "$BATTERY_LEVEL"
        touch "$NOTIFICATION_FLAG"
      fi
    else
      rm -f "$NOTIFICATION_FLAG"
    fi
  fi
}

battery_notify() {
  notify-send -i battery "Battery" "$(battery_status)"
}

main() {
  local cmd="${1:-status}"

  case "$cmd" in
    capacity)
      battery_capacity
      ;;
    monitor)
      battery_monitor
      ;;
    present)
      battery_present
      ;;
    remaining)
      battery_remaining
      ;;
    remaining-time)
      battery_remaining_time
      ;;
    status)
      battery_status
      ;;
    notify)
      battery_notify
      ;;
    *)
      echo "Uso: $0 {capacity|monitor|present|remaining|remaining-time|status}" >&2
      exit 1
      ;;
  esac
}

main "$@"

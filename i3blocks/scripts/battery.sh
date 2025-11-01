#!/bin/bash

# Tenta diferentes caminhos de bateria
if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    BAT="BAT0"
elif [ -f /sys/class/power_supply/BAT1/capacity ]; then
    BAT="BAT1"
else
    echo "No battery"
    exit 0
fi

battery_level=$(cat /sys/class/power_supply/$BAT/capacity)
battery_status=$(cat /sys/class/power_supply/$BAT/status)

# Define o ícone baseado no nível e status
if [ "$battery_status" = "Charging" ] || [ "$battery_status" = "Full" ]; then
    icon=""
elif [ "$battery_level" -ge 90 ]; then
    icon=""
elif [ "$battery_level" -ge 60 ]; then
    icon=""
elif [ "$battery_level" -ge 40 ]; then
    icon=""
elif [ "$battery_level" -ge 20 ]; then
    icon=""
else
    icon=""
fi

echo "$icon $battery_level%"

# Alerta crítico (muda a cor para vermelho)
if [ "$battery_level" -le 15 ] && [ "$battery_status" != "Charging" ]; then
    echo "#fb4934"
fi

#!/bin/bash
# Crie estes scripts em ~/.config/i3blocks/scripts/
# Dê permissão: chmod +x ~/.config/i3blocks/scripts/*.sh

# ============================================
# spotify.sh - Mostra música tocando no Spotify
# ============================================
cat > spotify.sh << 'EOF'
#!/bin/bash
if playerctl -p spotify status &> /dev/null; then
    status=$(playerctl -p spotify status)
    if [ "$status" = "Playing" ]; then
        artist=$(playerctl -p spotify metadata artist)
        title=$(playerctl -p spotify metadata title)
        echo " $artist - $title"
    fi
fi
EOF

# ============================================
# network.sh - Mostra status da rede
# ============================================
cat > network.sh << 'EOF'
#!/bin/bash
# Verifica Wi-Fi
if iwconfig 2>/dev/null | grep -q "ESSID"; then
    essid=$(iwgetid -r)
    echo "  $essid"
# Verifica Ethernet
elif ip link | grep -q "state UP"; then
    echo " "
else
    echo " disconnected"
fi
EOF

# ============================================
# volume.sh - Mostra volume atual
# ============================================
cat > volume.sh << 'EOF'
#!/bin/bash
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    echo " muted"
else
    echo " $volume%"
fi

# Para cliques
case $BLOCK_BUTTON in
    1) pavucontrol & ;; # Clique esquerdo
    3) pamixer -t ;; # Clique direito (mute/unmute)
esac
EOF

# ============================================
# battery.sh - Mostra status da bateria
# ============================================
cat > battery.sh << 'EOF'
#!/bin/bash
battery_level=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
battery_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")

if [ "$battery_status" = "Charging" ]; then
    icon=""
elif [ "$battery_level" -ge 90 ]; then
    icon=""
elif [ "$battery_level" -ge 60 ]; then
    icon=""
elif [ "$battery_level" -ge 40 ]; then
    icon=""
elif [ "$battery_level" -ge 20 ]; then
    icon=""
else
    icon=""
fi

echo "$icon $battery_level%"

# Alerta crítico
if [ "$battery_level" -le 15 ] && [ "$battery_status" != "Charging" ]; then
    echo "#fb4934" # Cor vermelha
fi
EOF

chmod +x spotify.sh network.sh volume.sh battery.sh

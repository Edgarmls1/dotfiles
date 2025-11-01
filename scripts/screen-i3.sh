#!/bin/bash

# Script para gerenciar monitores com xrandr
# Desativa o monitor do notebook quando um monitor externo está conectado

# Obtém o nome do monitor interno (notebook)
INTERNAL=$(xrandr | grep -E "^(eDP|LVDS|DSI)" | grep -o "^[^ ]*")

# Obtém o nome do monitor externo conectado (HDMI, DisplayPort, VGA, etc)
EXTERNAL=$(xrandr | grep " connected" | grep -vE "^(eDP|LVDS|DSI)" | grep -o "^[^ ]*" | head -n 1)

# Verifica se um monitor externo está conectado
if [ -n "$EXTERNAL" ]; then
    xrandr --output HDMI-2 --auto --primary --output eDP-1 --off
	echo "HDMI-2"
else
    xrandr --output eDP-1 --auto --primary
	echo "eDP-1"
fi

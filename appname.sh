#!/bin/bash

# Pega o app_id da janela ativa no Hyprland
app_id=$(hyprctl activewindow -j | jq -r '.class')

# Se não houver janela ativa, retorna vazio
if [ -z "$app_id" ]; then
    echo ""
else
    echo "$app_id"  # ou um nome formatado
fi

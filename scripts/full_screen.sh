#!/bin/bash

# Coloca a janela em foco em tela cheia
hyprctl dispatch fullscreen 1

# Obtém o ID da janela em foco
FOCUSED_WINDOW=$(hyprctl activewindow | grep 'Window ID' | awk '{print $3}')

# Obtém a lista de todas as janelas na área de trabalho atual
WINDOWS=$(hyprctl clients | grep 'Window ID' | awk '{print $3}')

# Move todas as janelas, exceto a janela em foco, para a próxima área de trabalho
for WINDOW in $WINDOWS; do
    if [[ "$WINDOW" != "$FOCUSED_WINDOW" ]]; then
        hyprctl dispatch movetoworkspace +1 $WINDOW
    fi
done
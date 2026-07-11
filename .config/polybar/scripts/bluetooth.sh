#!/usr/bin/env bash
#
# Módulo de bluetooth para o Polybar.
# Equivalente ao módulo "bluetooth" do waybar: ícone off/on e contador
# de dispositivos conectados. Clique abre o kitty com bluetui (definido
# no config.ini, não aqui).

ICON_ON=""
ICON_OFF=""

if ! command -v bluetoothctl >/dev/null 2>&1; then
  echo "${ICON_OFF}"
  exit 0
fi

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
  if [[ "$connected" -gt 0 ]]; then
    echo "${ICON_ON} ${connected}"
  else
    echo "${ICON_ON}"
  fi
else
  echo "${ICON_OFF}"
fi

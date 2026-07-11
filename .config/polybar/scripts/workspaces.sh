#!/usr/bin/env bash
#
# Módulo de workspaces do Hyprland para o Polybar.
# Equivalente ao "hyprland/workspaces" do teu waybar: mesmos ícones em
# hanzi (一二三四五六七八九), workspace ativo destacado, clique troca de
# workspace, e atualização em tempo real via socket do Hyprland.
#
# Dependências: jq, socat (ou nc com suporte a -U)
#
# Uso: workspaces.sh [nome_do_monitor]
#   Se passar o nome do monitor (ex: eDP-1), mostra só os workspaces
#   daquele monitor. Sem argumento, mostra todos.

set -uo pipefail

MONITOR_FILTER="${1:-}"

declare -A ICONS=(
  [1]="一" [2]="二" [3]="三" [4]="四" [5]="五"
  [6]="六" [7]="七" [8]="八" [9]="九"
)

icon_for() {
  local id=$1
  local last=$(( id % 10 ))
  [[ $last -eq 0 ]] && last=10
  echo "${ICONS[$last]:-$id}"
}

render() {
  local active_id
  active_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')

  local ws_json
  ws_json=$(hyprctl workspaces -j 2>/dev/null) || return

  local out=""
  while read -r id mon; do
    [[ -z "$id" ]] && continue
    if [[ -n "$MONITOR_FILTER" && "$mon" != "$MONITOR_FILTER" ]]; then
      continue
    fi

    local icon
    icon=$(icon_for "$id")

    if [[ "$id" == "$active_id" ]]; then
      # equivalente a #workspaces button.active (fundo branco, texto preto)
      out+="%{A1:hyprctl dispatch workspace ${id}:}%{F#000000}%{B#ffffff} ${icon} %{B-}%{F-}%{A}"
    else
      # equivalente a #workspaces button (cinza, sem fundo sólido)
      out+="%{A1:hyprctl dispatch workspace ${id}:}%{F#928374} ${icon} %{F-}%{A}"
    fi
  done < <(echo "$ws_json" | jq -r 'sort_by(.id)[] | "\(.id) \(.monitor)"')

  echo "$out"
}

render

# Atualiza em tempo real ouvindo os eventos do Hyprland (equivalente ao
# waybar recalcular sozinho quando muda de workspace/monitor)
SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if command -v socat >/dev/null 2>&1; then
  socat -U - UNIX-CONNECT:"$SOCKET" 2>/dev/null | while read -r line; do
    case "$line" in
      workspace*|createworkspace*|destroyworkspace*|moveworkspace*|focusedmon*)
        render
        ;;
    esac
  done
elif command -v nc >/dev/null 2>&1; then
  nc -U "$SOCKET" 2>/dev/null | while read -r line; do
    case "$line" in
      workspace*|createworkspace*|destroyworkspace*|moveworkspace*|focusedmon*)
        render
        ;;
    esac
  done
else
  echo "workspaces.sh: precisa de 'socat' ou 'nc -U' pra atualização em tempo real" >&2
fi

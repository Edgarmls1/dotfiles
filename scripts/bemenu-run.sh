#!/usr/bin/env bash
#
# Wrapper do bemenu-run com tema monocromático (preto/branco), Hack Nerd Font,
# sem cantos arredondados — combinando com waybar/polybar/picom.
#
# Uso: chama esse script no lugar de "i3-dmenu-desktop" / "rofi -show drun"

export BEMENU_OPTS="
  --fn 'Hack Nerd Font 12'
  --line-height 23
  -i
  --border 0
  --border-radius 0
  --bottom
  -w
  --nb '#000000'
  --nf '#928374'
  --tb '#000000'
  --tf '#ffffff'
  --fb '#000000'
  --ff '#ffffff'
  --hb '#ffffff'
  --hf '#000000'
  --ab '#000000'
  --af '#928374'
  --scrollbar none
"

exec bemenu-run

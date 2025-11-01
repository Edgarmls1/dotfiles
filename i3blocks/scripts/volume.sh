#!/bin/bash
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    echo "󰝟 "
else
    echo "󰕾  $volume%"
fi

# Para cliques
case $BLOCK_BUTTON in
    1) pavucontrol & ;; # Clique esquerdo
    3) blueberry &   ;; # Clique direito (mute/unmute)
	4) pamixer -i 5  ;;
	5) pamixer -d 5  ;;
esac

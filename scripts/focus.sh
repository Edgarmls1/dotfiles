#!/bin/bash

if pgrep -x qs > /dev/null; then
    killall qs
    hyprctl eval "hl.config({ general = { gaps_in = 0, gaps_out = 0 } })"
else
    qs &
    hyprctl eval "hl.config({ general = { gaps_in = 5, gaps_out = 15 } })"
fi

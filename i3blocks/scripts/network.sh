#!/bin/bash
# Verifica Wi-Fi
if iwconfig 2>/dev/null | grep -q "ESSID"; then
    essid=$(iwgetid -r)
    echo "   $essid"
# Verifica Ethernet
elif ip link | grep -q "state UP"; then
    echo " "
else
    echo "disconnected"
fi

case $BLOCK_BUTTOM in
	1 ) nm-applet &            ;;
	3 ) nm-connection-editor & ;;
esac

#! /usr/bin/bash

rm -rf ~/.config/nvim && mv nvim ~/.config/nvim
rm -rf ~/.config/hypr && mv hypr ~/.config/hypr
rm -rf ~/.config/i3 && mv i3 ~/.config/i3
rm -rf ~/.config/neofetch && mv neofetch ~/.config/neofetch
rm -rf ~/.config/rofi && mv rofi ~/.config/rofi
rm -rf ~/.config/waybar && mv waybar ~/.config/waybar
rm -rf ~/.config/yazi && mv nvim ~/.config/yazi

chmod +x appname.sh full_screen.sh network.sh rofi-wifi-menu.sh sys_update.sh

mv wallpapers ~/Imagens/wallpapers
mv .zshrc ~/.zshrc
mv appname.sh ~/appname.sh
mv full_screen.sh ~/full_screen.sh
mv network.sh ~/network.sh
mv rofi-wifi-menu.sh ~/rofi-wifi-menu.sh
mv sys_update.sh ~/sys_update.sh
mv archlogo.txt ~/archlogo.txt

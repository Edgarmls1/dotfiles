#! /bin/bash

echo repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc | sudo tee /etc/xbps.d/hyprland-void.conf

sudo xbps-install -S

sudo xbps-install hyprland hyprpaper hyprsunset hyprlock xdg-desktop-portal-hyprland nautilus rofi waybar fastfetch \
	yazi blueman pavucontrol network-manager-applet ghostty neovim notepadqq font-hack-ttf qt6ct gnome-tweaks firefox \
	lsd fzf htop btop cava bat okular vlc syncthing qimgv


#gruvbox icons
cd
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
mkdir -p ~/.icons
cd gruvbox-plus-icon-pack
mv Gruvbox-Plus-Dark ~/.icons/gruvbox
cd

git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh
cd

# enable dark mode in hyprland
mkdir -p ~/.config/xdg-desktop-portal/
cd ~/.config/xdg-desktop-portal/

CONFIG_CONTENT="[preferred]
default=hyprland;gtk"

CONFIG_FILE="hyprland-portals.conf"

echo "$CONFIG_CONTENT" >> "$CONFIG_FILE"
cd

clear

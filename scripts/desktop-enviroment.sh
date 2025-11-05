#! /bin/bash
sudo pacman -S hyprland hyprpaper hyprsunset hyprlock hyprshot kitty nautilus \
rofi waybar swaync fastfetch yazi blueberry pavucontrol network-manager-applet ghostty alacritty \
neovim gedit ttf-hack-nerd qt6ct gnome-tweaks ly firefox lsd fzf htop \
btop cava bat npm okular vlc xdg-desktop-portal-gtk xdg-desktop-portal-hyprland syncthing os-prober

yay -S hyprsome-git mpvpaper-git wlogout qimgv

# gruvbox icons
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

# enable ly
systemctl enable ly.service

# enable dark mode in hyprland
mkdir -p ~/.config/xdg-desktop-portal/
cd ~/.config/xdg-desktop-portal/

CONFIG_CONTENT="[preferred]
default=hyprland;gtk"

CONFIG_FILE="hyprland-portals.conf"

echo "$CONFIG_CONTENT" >> "$CONFIG_FILE"
cd

clear

#! /bin/bash
sudo pacman -S hyprland hyprpaper hyprsunset hyprlock hyprshot kitty nautilus \
rofi waybar swaync fastfetch yazi blueberry pavucontrol network-manager-applet \
neovim gedit ttf-hack-nerd qt6ct gnome-tweaks ly firefox lsd fzf htop i3 picom feh autotiling \
btop cava bat npm evince xdg-desktop-portal-gtk xdg-desktop-portal-hyprland syncthing os-prober

yay -S hyprsome-git mpvpaper-git wlogout qimgv

# gruvbox icons
cd
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
mkdir -p ~/.icons
cd gruvbox-plus-icon-pack
mv Gruvbox-Plus-Dark ~/.icons/gruvbox
cd

# grub customization
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes.git

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
cat << EOF
  installed packages:
    # lockscreen
      - ly
    # hyprland
      - hyprland -> window manager
      - hyprpaper -> wallpaper
      - hyprsunset -> blue light filter
      - hyprlock -> lockscreen
      - hyprshot -> printscreen
      - hyprsome -> multiple monitors
    # browser
      - firefox
    # terminal
      - kitty
    # file manager
      - nautilus -> GUI
      - yazi -> TUI
    # apps launcher
      - rofi
    # status bar
      - waybar
    # notification daemon
      - swaync
    # text editor
      - neovim -> TUI
      - gedit -> GUI
    # network manager
      - network-manager-applet
    # bluetooth manager
      - blueberry
    # theme switcher
      - qt6ct
      - gnome tweaks
    # logout menu
      - wlogout
    # animated wallpaper
      - mpvpaper
EOF

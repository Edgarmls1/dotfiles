#! /bin/bash
sudo pacman -S hyprland hyprpaper hyprsunset hyprlock hyprshot kitty nautilus rofi waybar swaync fastfetch yazi blueberry network-manager-applet neovim gedit ttf-jetbrains-mono-nerd qt6ct gnome-tweaks ly firefox lsd fzf

yay -S hyprsome-git mpvpaper-git wlogout

git clone https://github.com/mjkim0727/Pop-Extended.git
mkdir -p ~/.icons
cd Pop-Extended
mv Pop-Extended ~/.icons/pop
cd
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes.git

rm ~/.bashrc && mv ~/dotfiles/.bashrc ~/.bashrc
mv ~/dotfiles/scripts/sys_update.sh ~/sys_update.sh

clear 
cat << EOF
  installed packages:
    # lockscreen
      - ly (run 'systemctl enable ly.service' and reboot)
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
    # others
      - lsd
      - fzf
      - JetBrains nerd font
EOF

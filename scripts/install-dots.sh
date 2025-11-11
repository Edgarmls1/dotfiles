#! /bin/bash

cd ~/.config/

ln -s ~/dotfiles/nvim/ nvim
rm ~/.bashrc && ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/rofi/ rofi
ln -s ~/dotfiles/waybar/ waybar
ln -s ~/dotfiles/hypr/ hypr
ln -s ~/dotfiles/fastfetch/ fastfetch
ln -s ~/dotfiles/kitty/ kitty
ln -s ~/dotfiles/yazi/ yazi
ln -s ~/dotfiles/scripts/sys_update.sh ~/sys_update.sh

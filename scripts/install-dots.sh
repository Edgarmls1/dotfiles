#! /bin/bash

cd $HOME/.config/

ln -s $HOME/dotfiles/nvim/ nvim
rm $HOME/.bashrc && ln -s $HOME/dotfiles/.bashrc $HOME/.bashrc
ln -s $HOME/dotfiles/rofi/ rofi
ln -s $HOME/dotfiles/waybar/ waybar
ln -s $HOME/dotfiles/hypr/ hypr
ln -s $HOME/dotfiles/fastfetch/ fastfetch
ln -s $HOME/dotfiles/ghostty/ ghostty
ln -s $HOME/dotfiles/yazi/ yazi
ln -s $HOME/dotfiles/scripts/sys_update.sh $HOME/sys_update.sh

#!/bin/bash
sudo rm /var/lib/pacman/db.lck 2>/dev/null
echo "+--------------------------+"
echo "| fazendo update do sitema |"
echo "+--------------------------+"

echo "+----------------------------------+"
echo "| fazendo update de pacotes pacman |"
echo "+----------------------------------+"
sudo pacman -Syu --noconfirm 2>/dev/null
sudo pacman -Sc --noconfirm 2>/dev/null

echo "+----------------------------------+"
echo "| fazendo update de pacotes do AUR |"
echo "+----------------------------------+"
yay -Syu --noconfirm 2>/dev/null

echo "+-----------------------------------+"
echo "| fazendo update de pacotes flatpak |"
echo "+-----------------------------------+"
flatpak update -y 2>/dev/null

echo "+-----------------------------------+"
echo "| sistema atualizado com sucesso ;) |"
echo "+-----------------------------------+"

#------------------------------------------#

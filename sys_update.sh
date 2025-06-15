#!/bin/bash

cat << "EOF"
      _____            __                    __  __          __      __     
    / ___/__  _______/ /____  ____ ___     / / / /___  ____/ /___ _/ /____ 
    \__ \/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \ 
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/
  /____/\__, /____/\__/\___/_/ /_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/ 
       /____/                                /_/                           
 
 
 
 EOF

echo " "
echo "++==================================++"
echo "|| fazendo update de pacotes pacman ||"
echo "++==================================++"
sudo rm /var/lib/pacman/db.lck 2>/dev/null
sudo pacman -Syu --noconfirm 2>/dev/null
sudo pacman -Sc --noconfirm 2>/dev/null

echo "++==================================++"
echo "|| fazendo update de pacotes do AUR ||"
echo "++==================================++"
AUR
yay -Syu --noconfirm 2>/dev/null

echo "++===================================++"
echo "|| fazendo update de pacotes flatpak ||"
echo "++===================================++"
flatpak update -y 2>/dev/null

echo "++===================================++"
echo "|| sistema atualizado com sucesso ;) ||"
echo "++===================================++"

#------------------------------------------#

AUR() {
    if ! command -v yay &> /dev/null; then
        echo "Instalando o gerenciador de pacotes yay..."
        git clone https://aur.archlinux.org/yay.git || { echo "Falha ao clonar yay!"; exit 1; }
        cd yay || exit 1
        makepkg -si --noconfirm || { echo "Falha ao instalar yay!"; exit 1; }
        cd || exit 1
    else
        echo "yay já está instalado."
    fi
}

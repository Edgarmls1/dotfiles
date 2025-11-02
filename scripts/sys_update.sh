#!/bin/bash

cat << "EOF"
     _____            __                    __  __          __      __     
    / ___/__  _______/ /____  ____ ___     / / / /___  ____/ /___ _/ /____ 
    \__ \/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \ 
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/
  /____/\__, /____/\__/\___/_/ /_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/ 
       /____/                                /_/                           
 
EOF


if command -v pacman &> /dev/null; then
    echo " "
    echo "++==================================++"
    echo "|| fazendo update de pacotes pacman ||"
    echo "++==================================++"
    echo " "

    sudo rm /var/lib/pacman/db.lck 2>/dev/null
    sudo pacman -Syu --noconfirm 2>/dev/null
    sudo pacman -Sc --noconfirm 2>/dev/null
fi

if command -v yay &> /dev/null; then
    echo " "
    echo "++==================================++"
    echo "|| fazendo update de pacotes do AUR ||"
    echo "++==================================++"
    echo " "

    yay -Syu --noconfirm 2>/dev/null
fi

if command -v flatpak &> /dev/null; then
    echo " "
    echo "++===================================++"
    echo "|| fazendo update de pacotes flatpak ||"
    echo "++===================================++"
    echo " "

    flatpak update -y 2>/dev/null
fi


echo "++===================================++"
echo "|| sistema atualizado com sucesso ;) ||"
echo "++===================================++"

#------------------------------------------#

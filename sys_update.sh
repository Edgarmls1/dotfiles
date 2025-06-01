#!/bin/bash
sudo rm /var/lib/pacman/db.lck 2>/dev/null
echo "++==========================++"
echo "|| fazendo update do sitema ||"
echo "++==========================++"

echo "++==================================++"
echo "|| fazendo update de pacotes pacman ||"
echo "++==================================++"
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
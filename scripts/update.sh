#! /bin/bash

rm /var/lib/pacman/db.lck 2> /dev/null # gambiarra
#
# update.sh - faz update do sistema
# 
# Autor: edgar
#---------------------------------------#

UPDATES_FILE=$HOME/.cache/available_updates

#-------testes-------#

if ! command -v yay &> /dev/null; then
    echo "yay não encontrado, instalando..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

#--------------------#

#-------funçoes-------#

update() {
    cat << "EOF"
     _____            __                    __  __          __      __     
    / ___/__  _______/ /____  ____ ___     / / / /___  ____/ /___ _/ /____ 
    \__ \/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \ 
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/
  /____/\__, /____/\__/\___/_/ /_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/ 
       /____/                                /_/                           

EOF
    sudo pacman -Syu --noconfirm
    sudo pacman -Sc --noconfirm
    yay -Syu --noconfirm
    yay -Sc --noconfirm
    flatpak update -y

    if plugin=$(cat "$UPDATES_FILE" | grep "hyprland" 2> /dev/null); then
        hyprpm update
    fi
}

check() {
    echo " " > $UPDATES_FILE
    sudo pacman -Sy &> /dev/null
    if package=$(pacman -Qu 2> /dev/null); then
        echo "Package:" >> $UPDATES_FILE
        echo "$package" >> $UPDATES_FILE
    fi

    echo " " >> $UPDATES_FILE

    if aur=$(yay -Qua 2> /dev/null); then
        echo "AUR:" >> $UPDATES_FILE
        echo "$aur" >> $UPDATES_FILE
    fi

    if available=$(cat "$UPDATES_FILE" 2> /dev/null); then
        echo "$available"
        echo " "
        read -p "Do you want to upgrade now? [y/N] " choice
        case $choice in
            [Yy]*) update ;;
                *) exit 0 ;;
        esac
    else
        echo "No packages available for update!!!"
    fi
}

#---------------------#

#-------execuçao-------#

case $1 in
    -c) check  ;;
     *) update ;;
esac
#----------------------#

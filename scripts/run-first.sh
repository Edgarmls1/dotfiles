#! /usr/bin/bash

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

conda_config () {
    echo "Configurando o Anaconda..."
    cd /home/$USER/
    sudo pacman -Sy --noconfirm libxau libxi libxss libxtst libxcursor libxcomposite libxdamage libxfixes libxrandr libxrender mesa-libgl alsa-lib libglvnd
    if [ ! -f ~/Anaconda3-2025.06-1-Linux-x86_64.sh ]; then
        curl -O https://repo.anaconda.com/archive/Anaconda3-2025.06-1-Linux-x86_64.sh || { echo "Falha ao baixar o Anaconda!"; exit 1; }
    fi
    bash ~/Anaconda3-2025.06-1-Linux-x86_64.sh || { echo "Falha ao instalar o Anaconda!"; exit 1; }
    source ~/anaconda3/bin/activate
    conda init
}

git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local

AUR
conda_config

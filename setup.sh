#! /usr/bin/bash

menu() {
    clear
    echo "++================================++"
    echo "|| 1) clean (navegador e spotify) ||"
    echo "|| 2) games                       ||"
    echo "|| 3) dev                         ||"
    echo "|| 0) sair                        ||"
    echo "++================================++"
    read -p " " choice

    case $choice in
        1) clean                                                    ;;
        2) games                                                    ;;
        3) dev                                                      ;;
        0) exit 0                                                   ;;
        *) echo "Opção inválida. Tente novamente." ; sleep 1 ; menu ;;
    esac
}

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

clean() {
    clear
    echo "+-------------------------+"
    echo "| instalando config clean |"
    echo "+-------------------------+"

    AUR

    yay -S spotify
    echo ""
    echo "qual navegador deseja instalar?"
    echo "1 - zen"
    echo "2 - chrome"
    echo "3 - firefox"
    echo "4 - brave"
    echo "5 - todos"
    echo "0 - nenhum"
    read -p " " choice

    case $choice in 
        1) flatpak install flathub app.zen_browser.zen ;;
        2) yay -S google-chrome                        ;;
        3) sudo pacman -S firefox                      ;;
        4) yay -S brave-bin
        5) 
            flatpak install flathub app.zen_browser.zen 
            yay -S google-chrome brave-bin
            sudo pacman -S firefox
        ;;
        0) " "                                         ;;
        *) "opcao invalida"                            ;;
    esac


    ask_to_continue
}

games() {
    clear
    echo "+----------------------------+"
    echo "| instalando config p/ games |"
    echo "+----------------------------+"

    AUR

    yay -S steam heroic-games-launcher-bin lutris
    flatpak install flathub org.libretro.RetroArch com.discordapp.Discordcom.discordapp.Discord

    echo "+---------------------------------------+"
    echo "| config p/ games instalada com sucesso |"
    echo "+---------------------------------------+"

    ask_to_continue
}

dev() {
    clear
    echo "+--------------------------+"
    echo "| instalando config p/ dev |"
    echo "+--------------------------+"

    AUR

    sudo pacman -S neovim
    yay -S warp-terminal-bin visual-studio-code-bin
    flatpak install flathub md.obsidian.Obsidian

    read -p "Deseja instalar conda (python)? " choice1

    case $choice1 in 
        [Ss]*) 
            conda_config
        ;;
        *) "" ;;
    esac

    read -p "Deseja instalar postgres? " choice2

    case $choice2 in 
        [Ss]*) 
            sudo pacman -S postgres
            yay -S pgadmin4-desktop

            cd /usr/pgadmin4/venv/bin
            sudo rm python3
            sudo ln ~/anaconda3/bin/python3.12 python3
            cd
        ;;
        *) "" ;;
    esac

    echo "+-------------------------------------+"
    echo "| config p/ dev instalada com sucesso |"
    echo "+-------------------------------------+"

    ask_to_continue
}

bluetooth() {
    sudo pacman -S --noconfirm bluez bluez-utils
    sudo systemctl enable bluetooth
    sudo sed -i 's/^#AutoEnable=true/AutoEnable=true/' /etc/bluetooth/main.conf
    sudo systemctl restart bluetooth
}

conda_config () {
    echo "Configurando o Anaconda..."
    cd /home/$USER/
    sudo pacman -Sy --noconfirm libxau libxi libxss libxtst libxcursor libxcomposite libxdamage libxfixes libxrandr libxrender mesa-libgl alsa-lib libglvnd
    if [ ! -f ~/Anaconda3-2024.10-1-Linux-x86_64.sh ]; then
        curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh || { echo "Falha ao baixar o Anaconda!"; exit 1; }
    fi
    bash ~/Anaconda3-2024.10-1-Linux-x86_64.sh || { echo "Falha ao instalar o Anaconda!"; exit 1; }
    source ~/anaconda3/bin/activate
    conda init
}

ask_to_continue() {
    echo ""
    read -p "Deseja realizar outra operação? (s/n) " resp
    
    case $resp in
        [Ss]*) menu                             ;;
        *) echo "instalaçao concluida" ; exit 0 ;;
    esac
}

bluetooth
menu

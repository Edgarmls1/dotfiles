#! /usr/bin/bash

menu() {
    clear
    echo "++======================================================++"
    echo "||                                                      ||"
    echo "||              +------------------------+              ||"
    echo "||              | INSTALADOR DE DOTFILES |              ||"
    echo "||              +------------------------+              ||"
    echo "||                                                      ||"
    echo "|| Selecione qual configuração deseja instalar (0-4):   ||"
    echo "||                                                      ||"
    echo "|| 1) Neovim (nvim)                                     ||"
    echo "|| 2) Hyprland (hypr)                                   ||"
    echo "|| 3) Fastfetch                                         ||"
    echo "|| 4) Apenas scripts e wallpapers                       ||"
    echo "|| 0) Sair                                              ||"
    echo "||                                                      ||"
    echo "++======================================================++"
    read -p " " choice

    case $choice in
        1) nvim                                                     ;;
        2) hypr                                                     ;;
        3) fastfetch                                                ;;
        4) wallpapers_scripts                                       ;;
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

nvim() {
    sudo pacman -S --noconfirm neovim
    rm -rf ~/.config/nvim 2> /dev/null && mv nvim ~/.config/nvim
    
    ask_to_continue
}

hypr() {

    sudo pacman -S --noconfirm git hyprland hyprpaper hyprshot kitty nemo rofi waybar swaync
    yay -S --noconfirm hyprsome-git

    rm -rf ~/.config/hypr 2> /dev/null && mv hypr ~/.config/hypr
    rm -rf ~/.config/rofi 2> /dev/null && mv rofi ~/.config/rofi
    rm -rf ~/.config/waybar 2> /dev/null && mv waybar ~/.config/waybar
    
    chmod +x appname.sh full_screen.sh rofi-wifi-menu.sh

    mv appname.sh ~/appname.sh
    mv full_screen.sh ~/full_screen.sh
    mv rofi-wifi-menu.sh ~/rofi-wifi-menu.sh

    ask_to_continue
}

fastfetch() {

    sudo pacman -S --noconfirm fastfetch
    mv fastfetch ~/.config/fastfetch
    
    rm -rf ~/.config/fastfetch 2> /dev/null && mv fastfetch ~/.config/fastfetch

    mv archlogo.txt ~/archlogo.txt
    
    ask_to_continue
}

wallpapers_scripts() {
    sudo pacman -S --noconfirm fish yazi
    
    chmod +x sys_update.sh
    
    mv wallpapers ~/Imagens/wallpapers
    mv sys_update.sh ~/sys_update.sh
    rm -rf ~/.config/yazi 2> /dev/null && mv yazi ~/.config/yazi
    
    ask_to_continue
}

ask_to_continue() {
    echo ""
    read -p "Deseja realizar outra operação? (s/n) " resp
    
    case $resp in
        [Ss]*) menu                             ;;
        *) echo "instalaçao concluida" ; exit 0 ;;
    esac
}


AUR
menu

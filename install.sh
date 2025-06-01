#! /usr/bin/bash

menu() {
    clear
    echo "++======================================================++"
    echo "||                                                      ||"
    echo "||              +------------------------+              ||"
    echo "||              | INSTALADOR DE DOTFILES |              ||"
    echo "||              +------------------------+              ||"
    echo "||                                                      ||"
    echo "|| Selecione qual configuração deseja instalar (0-9):   ||"
    echo "||                                                      ||"
    echo "|| 1) Neovim (nvim)                                     ||"
    echo "|| 2) Hyprland (hypr)                                   ||"
    echo "|| 3) i3 WM                                             ||"
    echo "|| 4) Fastfetch                                         ||"
    echo "|| 5) Todos os itens acima                              ||"
    echo "|| 6) Apenas scripts e wallpapers                       ||"
    echo "|| 0) Sair                                              ||"
    echo "||                                                      ||"
    echo "++======================================================++"
    read -p " " choice

    case $choice in
        1) nvim                                                          ;;
        2) hypr                                                          ;;
        3) i3                                                            ;;
        4) fastfetch                                                     ;;
        5) all                                                           ;;
        6) wallpapers_scripts                                            ;;
        0) exit 0                                                        ;;
        *) echo "Opção inválida. Tente novamente." ; sleep 1 ; show_menu ;;
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

all() {

    AUR

    sudo pacman -S --noconfirm hyprland hyprpaper rofi waybar i3 feh yazi picom autotiling kitty dolphin
    yay -S --noconfirm hyprsome-git bumblebee-status-git
    
    rm -rf ~/.config/nvim && mv nvim ~/.config/nvim
    rm -rf ~/.config/hypr && mv hypr ~/.config/hypr
    rm -rf ~/.config/i3 && mv i3 ~/.config/i3
    rm -rf ~/.config/fastfetch && mv fastfetch ~/.config/fastfetch
    rm -rf ~/.config/rofi && mv rofi ~/.config/rofi
    rm -rf ~/.config/waybar && mv waybar ~/.config/waybar
    rm -rf ~/.config/yazi && mv nvim ~/.config/yazi

    chmod +x appname.sh full_screen.sh network.sh rofi-wifi-menu.sh sys_update.sh

    mv wallpapers ~/Imagens/wallpapers
    mv .zshrc ~/.zshrc
    mv appname.sh ~/appname.sh
    mv full_screen.sh ~/full_screen.sh
    mv network.sh ~/network.sh
    mv rofi-wifi-menu.sh ~/rofi-wifi-menu.sh
    mv sys_update.sh ~/sys_update.sh
    mv archlogo.txt ~/archlogo.txt
}

nvim() {
    sudo pacman -S --noconfirm neovim
    rm -rf ~/.config/nvim && mv nvim ~/.config/nvim
    
    ask_to_continue
}

hypr() {
    AUR

    sudo pacman -S --noconfirm git hyprland hyprpaper kitty dolphin rofi waybar
    yay -S --noconfirm hyprsome-git

    rm -rf ~/.config/hypr && mv hypr ~/.config/hypr
    rm -rf ~/.config/rofi && mv rofi ~/.config/rofi
    rm -rf ~/.config/waybar && mv waybar ~/.config/waybar

    chmod +x appname.sh full_screen.sh network.sh rofi-wifi-menu.sh

    mv appname.sh ~/appname.sh
    mv full_screen.sh ~/full_screen.sh
    mv network.sh ~/network.sh
    mv rofi-wifi-menu.sh ~/rofi-wifi-menu.sh

    ask_to_continue
}

i3() {
    AUR
    
    sudo pacman -S --noconfirm git i3 picom feh autotiling kitty dolphin
    yay -S --noconfirm bumblebee-status-git

    rm -rf ~/.config/i3 && mv i3 ~/.config/i3

    ask_to_continue
}

fastfetch() {
    sudo pacman -S --noconfirm fastfetch
    rm -rf ~/.config/fastfetch && mv fastfetch ~/.config/fastfetch
    mv archlogo.txt ~/archlogo.txt
    
    ask_to_continue
}

wallpapers_scripts() {
    sudo pacman -S --noconfirm zsh
    command -v zsh | sudo tee -a /etc/shells
    chsh -s $(which zsh)
    
    chmod +x sys_update.sh
    
    mv wallpapers ~/Imagens/wallpapers
    mv .zshrc ~/.zshrc
    mv sys_update.sh ~/sys_update.sh
    
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

menu

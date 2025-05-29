#!/usr/bin/bash

# Função para verificar dependências
check_dependencies() {
    local config=$1
    local missing=()

    case $config in
        "i3")
            local deps=("i3" "feh" "autotiling" "picom" "kitty" "dolphin" "bumblebee-status")
            for dep in "${deps[@]}"; do
              if ! command -v $dep &> /dev/null; then
                  read "  [Aviso] dependencias para i3wm estao faltando. Deseja instalar? (s/n)" choice
                  if [[ ! $choice =~ ^[Nn]$ ]]; then
                      sudo pacman -S i3 feh autotiling picom kitty dolphin
                      yay -S bumblebee-status
                  fi
                
              fi
            done
            ;;
        "hypr")
            local deps=("hyprland" "hyprpaper" "kitty" "dolphin" "rofi" "waybar", "hyprsome")
            for dep in "${deps[@]}"; do
              if ! command -v $dep &> /dev/null; then
                  read "  [Aviso] dependencias para hyprland estao faltando. Deseja instalar? (s/n)" choice
                  if [[ ! $choice =~ ^[Nn]$ ]]; then
                      sudo pacman -S hyprland hyprpaper rofi waybar kitty dolphin
                      yay -S hyprsome
                  fi
                
              fi
            done
            ;;
        "nvim") sudo pacman -S neovim ;;
        "fastfetch") sudo pacman -S fastfetch ;;
        "yazi") sudo pacman -S yazi ;;
        "zsh") sudo pacman -S zsh ;;
        *) return ;;
    esac
    return 0
}


# Função para mostrar o menu
show_menu() {
    clear
    echo "===================================="
    echo "  INSTALADOR DE CONFIGURAÇÕES DOTFILES  "
    echo "===================================="
    echo ""
    echo "Selecione quais configurações deseja instalar:"
    echo ""
    echo "1) Neovim (nvim)"
    echo "2) Hyprland (hypr)"
    echo "3) i3 WM"
    echo "4) Fastfetch"
    echo "5) Rofi"
    echo "6) Waybar"
    echo "7) Yazi"
    echo "8) Todos os itens acima"
    echo "9) Apenas scripts e wallpapers"
    echo "0) Sair"
    echo ""
    read -p "Digite sua escolha (0-9): " choice

    case $choice in
        1) move_config "nvim" ;;
        2) move_config "hypr" ;;
        3) move_config "i3" ;;
        4) move_config "fastfetch" ;;
        5) move_config "rofi" ;;
        6) move_config "waybar" ;;
        7) move_config "yazi" ;;
        8) move_all_configs ;;
        9) move_scripts_and_wallpapers ;;
        0) exit 0 ;;
        *) echo "Opção inválida. Tente novamente." ; sleep 1 ; show_menu ;;
    esac
}

# Função para mover uma configuração específica
move_config() {
    local config_name=$1

    echo ""
    echo "=== Verificando dependências para $config_name ==="
    if ! check_dependencies "$config_name"; then
        echo "Instalação de $config_name cancelada."
        ask_to_continue
        return
    fi
    
    echo "Instalando configuração do $config_name..."
    
    rm -rf ~/.config/"$config_name"
    if mv "$config_name" ~/.config/"$config_name"; then
        echo "$config_name instalado com sucesso!"
    else
        echo "Erro ao instalar $config_name. O diretório de origem existe?"
    fi
    
    ask_to_continue
}

# Função para mover todas as configurações
move_all_configs() {
    echo "Instalando todas as configurações..."

    local all_configs=("nvim" "hypr" "i3" "fastfetch" "rofi" "waybar" "yazi" "zsh")
    for config in "${all_configs[@]}"; do
        check_specific_dependencies "$config"
    done
    
    for config in "${all_configs[@]}"; do
        rm -rf ~/.config/"$config"
        if mv "$config" ~/.config/"$config"; then
            echo "$config instalado com sucesso!"
        else
            echo "Erro ao instalar $config. O diretório de origem existe?"
        fi
    done
    
    move_scripts_and_wallpapers
}

# Função para mover scripts e wallpapers
move_scripts_and_wallpapers() {
    echo "Instalando scripts e wallpapers..."
    
    # Mover scripts
    local scripts=("appname.sh" "full_screen.sh" "network.sh" "rofi-wifi-menu.sh" "sys_update.sh")
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            if mv "$script" ~/"$script"; then
                echo "$script movido e tornando executável com sucesso!"
            else
                echo "Erro ao mover $script"
            fi
        else
            echo "$script não encontrado no diretório atual"
        fi
    done
    
    # Mover wallpapers
    if [ -d "wallpapers" ]; then
        mkdir -p ~/Imagens
        if mv wallpapers ~/Imagens/wallpapers; then
            echo "Wallpapers instalados com sucesso!"
        else
            echo "Erro ao mover wallpapers"
        fi
    else
        echo "Diretório wallpapers não encontrado"
    fi
    
    # Mover .zshrc e archlogo.txt
    if [ -f ".zshrc" ]; then
        if mv .zshrc ~/.zshrc; then
            echo ".zshrc instalado com sucesso!"
        else
            echo "Erro ao mover .zshrc"
        fi
    else
        echo ".zshrc não encontrado"
    fi
    
    if [ -f "archlogo.txt" ]; then
        if mv archlogo.txt ~/archlogo.txt; then
            echo "archlogo.txt instalado com sucesso!"
        else
            echo "Erro ao mover archlogo.txt"
        fi
    else
        echo "archlogo.txt não encontrado"
    fi
    
    ask_to_continue
}

# Função para perguntar se deseja continuar
ask_to_continue() {
    echo ""
    read -p "Deseja realizar outra operação? (s/n) " answer
    case $answer in
        [Ss]*) show_menu ;;
        *) echo "Instalação concluída!" ; exit 0 ;;
    esac
}

# Mostrar menu principal
show_menu

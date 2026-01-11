#! /bin/bash

#
# install.sh - instala a configuração dos dotfiles
# 
# Autor: edgar - github.com/Edgarmls1
#---------------------------------------#
# Script feito para instalar, a partir de uma instalação minima de Archlinux, configurações e apps
# 
#---------------------------------------#
# Historico: 
#
# v1.0 12/11/2025, edgar:
#   - criação do script
#
# v1.1 12/11/2025, edgar:
#   - adição de modo silencioso com barra de progresso
#   - completação da função instala
#
# v1.2 13/11/2025, edgar:
#   - suporte para Linux e macOS
#
#-------variaveis-------#

MENSAGEM_HELP="

    $(basename $0) - [OPÇÕES]
    
    -h - ajuda
    -v - versao
    -q - modo silencioso (com barra de progresso)
    
"
VERSAO="v1.2"
DEFAULT=0
SILENCIOSO=0
OS_TYPE=$(uname -s)

#---------------------#

#-------testes--------#

# Instalar yay apenas no Linux
if [[ "$OS_TYPE" == "Linux" ]]; then
    if ! command -v yay &> /dev/null; then
        echo "yay não encontrado, instalando..."
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    
    # Instalar ble.sh
    if [[ ! -d ~/.local/share/blesh ]]; then
        echo "Instalando ble.sh..."
        git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
        make -C ble.sh install PREFIX=~/.local
        rm -rf ble.sh
    fi
fi

#--------------------#

#-----funções-------#

show_progress() {
    local msg="$1"
    local pid=$2
    local delay=0.1
    local spinstr='|/-\'
    
    echo -ne "$msg "
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf "[%c]" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b"
    done
    echo -ne "\r$msg [✓]\n"
}

hyprde () {
    local de_list="hyprland hyprpaper hyprsunset hyprlock hyprshot nautilus waybar swaync fastfetch yazi blueberry pavucontrol network-manager-applet kitty neovim ttf-hack-nerd qt6ct gnome-tweaks ly firefox lsd fzf htop btop cava bat npm okular vlc xdg-desktop-portal-gtk xdg-desktop-portal-hyprland syncthing os-prober"
    local aur_list="hyprsome-git mpvpaper-git qimgv hyprlight anyrun"

    if [[ $SILENCIOSO -eq 1 ]]; then
        echo "Instalando pacotes do Hyprland DE..."
        
        echo -ne "Instalando pacotes oficiais..."
        sudo pacman -S --noconfirm $de_list > /dev/null 2>&1 &
        show_progress "Instalando pacotes oficiais" $!
        
        echo -ne "Instalando pacotes AUR..."
        yay -S --noconfirm $aur_list > /dev/null 2>&1 &
        show_progress "Instalando pacotes AUR" $!
    else
        echo "Instalando pacotes do Hyprland DE..."
        sudo pacman -S --noconfirm $de_list
        yay -S --noconfirm $aur_list
    fi

    if [[ $SILENCIOSO -eq 1 ]]; then
        echo -ne "Instalando ícones Gruvbox..."
        (
            cd ~ || exit
            git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git > /dev/null 2>&1
            mkdir -p ~/.icons
            cd gruvbox-plus-icon-pack || exit
            mv Gruvbox-Plus-Dark ~/.icons/gruvbox
            cd ~ || exit
            rm -rf gruvbox-plus-icon-pack
        ) &
        show_progress "Instalando ícones Gruvbox" $!
    else
        echo "Instalando ícones Gruvbox..."
        cd ~ || exit
        git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
        mkdir -p ~/.icons
        cd gruvbox-plus-icon-pack || exit
        mv Gruvbox-Plus-Dark ~/.icons/gruvbox
        cd ~ || exit
        rm -rf gruvbox-plus-icon-pack
    fi

    if [[ $SILENCIOSO -eq 1 ]]; then
        echo -ne "Instalando tema Orchis..."
        (
            cd ~ || exit
            git clone https://github.com/vinceliuice/Orchis-theme.git > /dev/null 2>&1
            cd Orchis-theme || exit
            ./install.sh > /dev/null 2>&1
            cd ~ || exit
            rm -rf Orchis-theme
        ) &
        show_progress "Instalando tema Orchis" $!
    else
        echo "Instalando tema Orchis..."
        cd ~ || exit
        git clone https://github.com/vinceliuice/Orchis-theme.git
        cd Orchis-theme || exit
        ./install.sh
        cd ~ || exit
        rm -rf Orchis-theme
    fi

    echo "Habilitando ly.service..."
    sudo systemctl enable ly@tty2

    echo "Configurando dark mode..."
    mkdir -p ~/.config/xdg-desktop-portal/
    
    cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf << EOF
[preferred]
default=hyprland;gtk
EOF
    
    cd ~ || exit
}

links () {
    echo "Criando links simbólicos..."
    
    mkdir -p ~/.config
    cd ~/.config/ || exit

    if [[ "$OS_TYPE" == "Linux" ]]; then
        ln -sf ~/dotfiles/hypr/ hypr
        ln -sf ~/dotfiles/waybar/ waybar
        ln -sf ~/dotfiles/scripts/update.sh ~/update.sh
    fi
    
    ln -sf ~/dotfiles/nvim/ nvim
	ln -sf ~/dotfiles/kitty/ kitty
    ln -sf ~/dotfiles/yazi/ yazi
    ln -sf ~/dotfiles/fastfetch/ fastfetch

    rm -f ~/.bashrc
    ln -sf ~/dotfiles/.bashrc ~/.bashrc
	ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
    
    echo "Links simbólicos criados com sucesso!"
    cd ~ || exit
}

instala () {
    if [[ $SILENCIOSO -eq 1 ]]; then
        echo ""
        echo "=== Iniciando instalação (modo silencioso) ==="
        echo ""
    else
        echo ""
        echo "=== Iniciando instalação ==="
        echo ""
    fi
    
    case "$OS_TYPE" in
        Linux)
            echo "Sistema detectado: Linux"
            read -p "deseja instalar somente o dotfiles? s/N" choice

			case "$choice" in
				[Ss]*) links ;;
				*) 
					hyprde
					links
				;;
			esac
        ;;
        Darwin)
            echo "Sistema detectado: macOS"
            links
        ;;
        *)
            echo "Sistema operacional não suportado: $OS_TYPE"
            exit 1
            ;;
    esac
    
    echo ""
    echo "✓ Instalação concluída com sucesso!"
    echo ""
    
    if [[ "$OS_TYPE" == "Linux" ]]; then
        echo "Reinicie o sistema para aplicar todas as configurações."
    fi
}

#---------------------#

if [[ ! -d ~/pyenv ]]; then
    echo "Criando ambiente virtual Python..."
    python3 -m venv ~/pyenv
fi

#-------execução-------#

case $1 in
    -h) echo "$MENSAGEM_HELP" && exit 0 ;;
    -v) echo "$VERSAO" && exit 0        ;;
    -q) SILENCIOSO=1; DEFAULT=1         ;;
    *) DEFAULT=1                        ;;
esac

[ $DEFAULT -eq 1 ] && instala

#----------------------#

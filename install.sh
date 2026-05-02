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

#---------------------#

#-------testes--------#

# Instalar yay apenas no Linux
if ! command -v yay &> /dev/null; then
	sudo pacman -S git base-devel
	echo "yay não encontrado, instalando..."
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay	
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
	sudo sed -i "s/#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf
	sudo sed -i "s/ParallelDownloads = 5/ParallelDownloads = 10/g" /etc/pacman.conf

    local pkg_list="hyprland hyprpaper hyprsunset hyprlock hyprshot thunar waybar swaync fastfetch yazi bluetui pavucontrol gazelle-tui kitty neovim ttf-hack-nerd qt6ct gnome-tweaks ly firefox lsd fzf htop btop cava bat npm zathura xdg-desktop-portal-gtk xdg-desktop-portal-hyprland syncthing os-prober hyprsome-git mpv qimgv anyrun zathura-pdf-mupdf pokeget lnch pyright gopls jdtls rust-analyzer bash-language-server zsh bibata-cursor-theme-bin yaru-icon-theme"

    if [[ $SILENCIOSO -eq 1 ]]; then
        echo "Instalando pacotes do Hyprland DE..."
        
        yay -S --noconfirm $pkg_list > /dev/null 2>&1 &
        show_progress "Instalando pacotes" $!
        
    else
        echo "Instalando pacotes do Hyprland DE..."
        yay -S --noconfirm $pkg_list
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
	sudo sed -i "s/animation = none/animation = /home/edgar/dotfiles/blackhole.dur/g" /etc/ly/config.ini

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

	ln -sf ~/dotfiles/hypr/ hypr
	ln -sf ~/dotfiles/waybar/ waybar
	ln -sf ~/dotfiles/scripts/update.sh ~/update.sh

    ln -sf ~/dotfiles/nvim/ nvim
	mkdir kitty
    ln -sf ~/dotfiles/kitty/kitty-cats.conf kitty/kitty.conf
    ln -sf ~/dotfiles/fastfetch/ fastfetch
	ln -sf ~/dotfiles/yazi/ yazi
	ln -sf ~/dotfiles/wleave/ wleave

	rm ~/.bashrc 
	ln -sf ~/dotfiles/.bashrc ~/.bashrc
    ln -sf ~/dotfiles/.zshrc ~/.zshrc
	chsh -s /bin/zsh
    
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
    read -p "deseja instalar somente o dotfiles? s/N" choice

	case "$choice" in
		[Ss]*) links ;;
			*) 
				hyprde
				links
			;;
	esac
        
    echo ""
    echo "✓ Instalação concluída com sucesso!"
    echo ""
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

clear
echo "em 10 segundos voce sera redirecionado para o programa de instalação dos seus pacotes (navegador, steam, spotify, vs code)"
sleep 10
exec ~/dotfiles/scripts/setup.sh

clear
echo "sistema reiniciando em 5 segundos..."
sleep 5
shutdown -r now

#----------------------#

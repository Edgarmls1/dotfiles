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
#-------variaveis-------#

HELP_MSG="

    $(basename $0) - [OPTIONS]
    
    -h - help
    -v - version
    -q - quiet mode
    
"
VERSION="v1.2"
DEFAULT=0
QUIET=0
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$DOTFILES_DIR")"

#---------------------#

#-------testes--------#

aur() {
	if ! command -v yay &> /dev/null; then
		sudo pacman -S git base-devel
		echo "yay not found, installing now..."
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm
		cd ..
		rm -rf yay	
	fi
}
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
    local pkg_list="7zip anyrun bash-language-server bat bluetui btop cava dunst fastfetch firefox flatpak fzf gazelle-tui gopls gnome-tweaks htop hyprland hyprlock hyprpaper hyprshot hyprsome-git hyprsunset jdtls kitty lsd ly mpv mpvpaper nemo neovim npm noto-fonts-emoji os-prober papirus-folders-git papirus-icon-theme pavucontrol pokeget pyright qimgv qt6ct qutebrowser rust-analyzer stow ttf-hack-nerd unzip xdg-desktop-portal-gtk xdg-desktop-portal-hyprland yazi waybar wayweather wget wleave zathura zathura-pdf-mupdf zsh"

    if [[ $QUIET -eq 1 ]]; then
        echo "Instaling pakages for making hyprland an DE..."
        
        yay -S --noconfirm $pkg_list > /dev/null 2>&1 &
        show_progress "Instaling pakages" $!
        
    else
        echo "Instaling pakages for making hyprland an DE..."
        yay -S --noconfirm $pkg_list
    fi

    if [[ $QUIET -eq 1 ]]; then
        echo -ne "Instaling Orchis theme..."
        (
            cd ~ || exit
            git clone https://github.com/vinceliuice/Orchis-theme.git > /dev/null 2>&1
            cd Orchis-theme || exit
            ./install.sh > /dev/null 2>&1
            cd ~ || exit
            rm -rf Orchis-theme
        ) &
        show_progress "Orchis theme instaled" $!
    else
        echo "Instaling Orchis theme..."
        cd ~ || exit
        git clone https://github.com/vinceliuice/Orchis-theme.git
        cd Orchis-theme || exit
        ./install.sh
        cd ~ || exit
        rm -rf Orchis-theme
    fi

    echo "Enabling ly.service..."
    sudo systemctl enable ly@tty2
	cd $DOTFILES_DIR/dotfiles/ly/
	sudo cp blackhole-smooth-240x67.dur /etc/ly/
	sudo rm /etc/ly/config.ini
	sudo cp config.ini /etc/ly/
	cd ~ || exit

	papirus-folders -C black --theme Papirus-Dark

    echo "Configuring dark mode..."
    mkdir -p ~/.config/xdg-desktop-portal/
    
    cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf << EOF
[preferred]
default=hyprland;gtk
EOF
    
    cd ~ || exit
}

instala () {
    if [[ $SILENCIOSO -eq 1 ]]; then
        echo ""
        echo "=== Instaling (quiet mode) ==="
        echo ""
    else
        echo ""
        echo "=== Instaling ==="
        echo ""
    fi
    hyprde

    mkdir kitty
    ln -sf ~/dotfiles/kitty/kitty-purple.conf kitty/kitty.conf
    rm ~/.bashrc 
    chsh -s /bin/zsh
        
    echo ""
    echo "✓ Instalation copleted!"
    echo ""
}

#---------------------#

if [[ ! -d ~/pyenv ]]; then
    echo "Creating a Python virtual enviroment..."
    python3 -m venv ~/pyenv
fi

#--------------------#

sudo fallocate -l 16G /swapfile -v
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab

#-------execução-------#

case $1 in
    -h) echo "$HELP_MSG" && exit 0 ;;
    -v) echo "$VERSION" && exit 0        ;;
    -q) QUIET=1; DEFAULT=1         ;;
    *) DEFAULT=1                        ;;
esac

echo ""
read -p "Are you in an arch based distro? [Y/n]" choice

case $choice in
	[Nn]*)
		cd $DOTFILES_DIR
		stow .
		echo "Now you have to install by your own -> anyrun, dunst, fastfetch (pokeget for pokemon sprits), hyprland, hyprpaper, hyprlock, kitty, neovim, qutebrowser, waybar, wleave and yazi "
		;;
	*)

		[ $DEFAULT -eq 1 ]
		aur
		instala
		cd $DOTFILES_DIR
		stow .
		;;
esac

clear
echo "In 5 seconds you will be redirected to apps config...\n"
for i in $(seq 5 -1 1); do
    printf "$i"
	sleep 0.3
	printf "."
	sleep 0.3
	printf "."
	sleep 0.3
	printf "."
    sleep 0.1
done
printf "\n"
exec "$DOTFILES_DIR/scripts/setup.sh"

#----------------------#

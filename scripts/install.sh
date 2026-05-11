#! /bin/bash

#
# install.sh - install dotfiles configs
# 
# Author: edgar - github.com/Edgarmls1
#-------variables-------#

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$DOTFILES_DIR")"

#-----functions-----#

aur() {
	# aur?
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

enable_ly() {
	read -p "Do you want to install & enable ly? [y/N] " choice

	case $reboot in
		[Yy]*)
			yay -S ly

			echo "What is yours current display manager?"
			echo "1 - gdm"
			echo "2 - sddm"
			echo "3 - i will disable by my self"
			echo "4 - none"
			read -p "" dm

			case $dm in
				1) sudo systemctl disable gdm                               ;;
				2) sudo systemctl disable sddm                              ;;
				3) echo "after disable run 'sudo systemctl enable ly@tty2'" ;;
				4) echo ""                                                  ;;
			esac

			echo "Enabling ly.service..."
			sudo systemctl enable ly@tty2 2> /dev/null
			cd $DOTFILES_DIR/ly/
			sudo cp blackhole-smooth-240x67.dur /etc/ly/
			sudo rm /etc/ly/config.ini
			sudo cp config.ini /etc/ly/
			cd ~ || exit
			;;
	esac
}

themes() {
	echo "Instaling Orchis theme..."
	cd ~ || exit
	git clone https://github.com/vinceliuice/Orchis-theme.git
	cd Orchis-theme || exit
	./install.sh
	cd ~ || exit
	rm -rf Orchis-theme

	papirus-folders -C black --theme Papirus-Dark 2> /dev/null
}

dark_mode() {
	echo "Configuring hyprland dark mode..."
	mkdir -p ~/.config/xdg-desktop-portal/

	cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf << EOF
[preferred]
default=hyprland;gtk
EOF
}

install () {
	echo ""
	echo "=== Instaling ==="
	echo ""

    local pkg_list="7zip anyrun bash-language-server bat bluetui btop cava dunst fastfetch firefox flatpak fzf gazelle-tui gopls gnome-tweaks htop hyprland hyprlock hyprpaper hyprshot hyprsome-git hyprsunset jdtls kitty lsd mpv mpvpaper nemo neovim npm noto-fonts-emoji os-prober papirus-folders-git papirus-icon-theme pavucontrol pokeget pyright qimgv qt6ct qutebrowser rust-analyzer stow ttf-hack-nerd unzip xdg-desktop-portal-gtk xdg-desktop-portal-hyprland yazi waybar wayweather wget wleave zathura zathura-pdf-mupdf zsh"

	yay -S --noconfirm $pkg_list
	enable_ly
	themes
	dark_mode

    mkdir -p ~/.config/kitty
    ln -sf kitty/kitty-purple.conf ~/.config/kitty/kitty.conf

    mkdir -p ~/.config/qutebrowser ~/.config/qutebrowser/yt-style/
    ln -sf qutebrowser/config.py ~/.config/qutebrowser/config.py
    ln -sf qutebrowser/yt-style/youtube-tweaks.css ~/.config/qutebrowser/yt-style/youtube-tweaks.css


	if [ "$(echo $SHELL)" == "/bin/bash" ]; then
    	chsh -s /bin/zsh
	else
		rm ~/.zshrc
	fi

	cd $DOTFILES_DIR
	stow .

    cd ~ || exit

    echo ""
    echo "✓ Instalation copleted!"
    echo ""
}

redirect_to_setup() {
	clear
	echo "In 5 seconds you will be redirected to apps config..."
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
}

#---------------------#

if [[ ! -d ~/pyenv ]]; then
    echo "Creating a Python virtual enviroment..."
    python3 -m venv ~/pyenv
fi

#--------------------#

#-------swap-------#

read -p "Do you want to add swap? [y/N] " choice

case $reboot in
	[Yy]*)
		sudo fallocate -l 16G /swapfile -v
		sudo chmod 600 /swapfile
		sudo mkswap /swapfile
		sudo swapon /swapfile
		echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
		;;
esac

#--------------------#

#-------exec------#

install
redirect_to_setup

#----------------------#

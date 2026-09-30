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
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm
		cd ..
		rm -rf yay
	fi
}

virtualization() {
    yay -S qemu-full libvirt virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat edk2-ovmf swtpm

    sudo systemctl enable libvirtd.service
    sudo systemctl enable virtlogd.service

    sudo usermod -aG libvirt,kvm $USER
}

themes() {
	cd
	git clone https://github.com/vinceliuice/Orchis-theme.git
	cd Orchis-theme
	./install.sh
	cd ..
	rm -rf Orchis-theme

	papirus-folders -C yaru --theme Papirus-Dark 2> /dev/null
}

dark_mode() {
	mkdir -p ~/.config/xdg-desktop-portal/

	cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf << EOF
[preferred]
default=hyprland;gtk
EOF
}

install () {
    local pkg_list="7zip alacritty bash-language-server bat bc bemenu bemenu-wayland bluetui btop cava chhsich-nerd-font cmatrix \
       dolphin dunst fastfetch firefox flatpak fzf gazelle-tui gopls gnome-disk-utility \
       htop hyprland hyprlock hyprpaper hyprshot hyprsunset j4-dmenu-desktop jdtls kitty lsd lxappearance ly mpc mpd mpv mpvpaper \
       neovim npm noto-fonts-emoji os-prober papirus-folders-git papirus-icon-theme pavucontrol pokeget power-profiles-daemon pyright \
       qimgv qt5-graphicaleffects qt5-quickcontrols2 qt5-wayland qt6ct qt6-declarative qt6-svg qt6-wayland qutebrowser \
       ranger rust-analyzer stow ttf-hack-nerd unrar unzip \
       xdg-desktop-portal-gtk xdg-desktop-portal-hyprland waybar wget wleave zathura zathura-pdf-mupdf zellij zsh"

	aur
	yay -S --noconfirm $pkg_list
    virtualization
	themes
	dark_mode

    sudo systemctl enable ly@tty2 2> /dev/null

    if ! "$HOST" == "mobile-pc"; then
        hyprpm add https://github.com/zjeffer/split-monitor-workspaces
        hyprpm enable split-monitor-workspaces
    fi

	if [ ! "$(echo $SHELL)" == "/bin/zsh" ]; then
    	chsh -s /bin/zsh
	fi

	cd $DOTFILES_DIR
	stow .

    cd ~ || exit

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
    python3 -m venv ~/pyenv
fi

#--------------------#

#-------swap-------#

read -p "Do you want to add swap? [y/N] " choice

case $choice in
	[Yy]*)
        read -p "how many gigas? " gb
		sudo fallocate -l ${gb}G /swapfile -v
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

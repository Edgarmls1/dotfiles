#!/bin/bash

clear
echo "##########################################################"
echo "##########################################################"
echo "##    _             _       ___           _        _ _  ##"
echo "##   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | | ##"
echo "##  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | | ##"
echo "## / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | | ##"
echo "##/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_| ##"
echo "##########################################################"
echo "##########################################################"

#############
# variaveis #
#############
teclado="br-abnt2"
timezone="America/Belem"
idioma="en_US.UTF-8"
hostname="arch"
username="edgar"

#####################
# partição do disco #
#####################
lsblk
read -p "Insira o nome da partição EFI (ex. sda1): " sda1
read -p "Insira o nome da partição ROOT (ex. sda2): " sda2

#########################
# sincronizando relogio #
#########################
timedatectl set-ntp true

#######################
# formatação do disco #
#######################
mkfs.fat -F 32 /dev/$sda1
mkfs.btrfs /dev/$sda2

####################
# montando o disco #
####################
mount /dev/$sda2 /mnt
mkdir -p /mnt/efi
mount /dev/$sda1 /mnt/efi

#########################
# instalação de pacotes #
#########################
pacman -Sy archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

sudo reflactor --country Brazil --age 24 --protocol https --sort rate --latest 20 --save /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel git linux linu-firmware vim openssh reflactor btrfs-progs grub efibootmgr grub-btrfs inotify-tools networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber man sudo intel-ucode amd-ucode



#########
# fstab #
#########
genfstab -U /mnt >> /mnt/etc/fstab

######################
# entrando como root #
######################
arch-chroot /mnt

#####################
# instalndo pacotes #
#####################

pcaman -Syy

pacman --noconfirm -S xdg-desktop-portal-wlr dialog linux-headers avahi xdg-user-dirs xdg-utils bluez bluez-utils cups alsa-utils bash-completion rsync acpi acpi_call dnsmasq ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g exa xorg xorg-xinit xclip grub-btrfs xf86-video-amdgpu xf86-video-nouveau xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib inxi

##############################
# setando relogio do sistema #
##############################
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

############################
# setando idioma e teclado #
############################
echo "$idioma UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=$idioma" >> /etc/locale.conf

echo "KEYMAP=$teclado" >> /etc/vconsole.conf

########################
# configuração do host #
########################
echo "$hostname" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

################
# root e users #
################
clear
echo "Escolha a senha do root: "
passwd root

sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g" /etc/sudoers

echo "Adicionando o usuario $username"
useradd -mG wheel $username
passwd $username

#######################
# abilitando serviços #
#######################
systemctl enable NetworkManager
systemctl enable bluetooth

###############
# reiniciando #
###############
clear
echo "Seu sitema sera reiniciado em 5 segundos\n"
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
shutdown -r now 


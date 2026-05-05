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

sudo reflector --country Brazil --age 24 --protocol https --sort rate --latest 20 --save /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector btrfs-progs grub efibootmgr grub-btrfs inotify-tools networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber man sudo intel-ucode amd-ucode

#########
# fstab #
#########
genfstab -U /mnt >> /mnt/etc/fstab

######################
# entrando como root #
######################
arch-chroot /mnt curl -fsSL https://raw.githubusercontent.com/Edgarmls1/dotfiles/refs/heads/main/archinstall/config.sh | sh

#! /bin/bash

rm /var/lib/pacman/db.lck 2> /dev/null # gambiarra
#
# update.sh - faz update do sistema
# 
# Autor: edgar
#---------------------------------------#

#-------testes-------#

if ! command -v yay &> /dev/null; then
    echo "yay não encontrado, instalando..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

#--------------------#

#-------funçoes-------#

spinner () {
	local pid=$1
	local msg=$2
	local spin='|/-\'

	printf " "
	while kill -0 $pid 2> /dev/null; do
		i=$(( (i+1) %4 ))
		printf "\r${msg} ${spin:$i:1}"
		sleep 0.1
	done
	printf "\r${msg} ✓\n"
}

executar () {
	local cmd=$1
	local msg=$2

	eval "$cmd" > /dev/null 2>&1 &
	local pid=$!
	spinner $pid "$msg"
	wait $pid
	return $?
}

atualiza () {
    if [[ $SILENCIOSO -eq 1 ]]; then
		executar "sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm" "[1/3] Atualizando pacotes do sistema"
		executar "yay -Syu --noconfirm && yay -Sc --noconfirm" "[2/3] Atualizando pacotes do sistema"
		executar "flatpak update -y" "[3/3] Atualizando pacotes do sistema"
	
	else
		cat << "EOF"
     _____            __                    __  __          __      __     
    / ___/__  _______/ /____  ____ ___     / / / /___  ____/ /___ _/ /____ 
    \__ \/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \ 
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/
  /____/\__, /____/\__/\___/_/ /_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/ 
       /____/                                /_/                           

EOF
		sudo pacman -Syu --noconfirm
		sudo pacman -Sc --noconfirm
	    yay -Syu --noconfirm
		yay -Sc --noconfirm
		flatpak update -y
    fi
}

#---------------------#

#-------execuçao-------#

case $1 in
    -h) echo "$MENSAGEM_USO" && exit 0 ;;
    -v) echo "$VERSAO" && exit 0       ;;
    -q) SILENCIOSO=1; DEFAULT=1        ;;
    *) DEFAULT=1                       ;;
esac

[ $DEFAULT -eq 1 ] && atualiza
#----------------------#

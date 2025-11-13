#! /bin/bash

rm /var/lib/pacman/db.lck 2> /dev/null # gambiarra
#
# sys_update.sh - faz update do sistema
# 
# Autor: edgar
#---------------------------------------#
# script para atualizar o sistema e pacotes de distribuiçoes linux baseadas em Arch
# 
# exemplo de uso:
#   ./sys_update.sh -q
#     neste exemplo ficará em modo silecioso
#---------------------------------------#
# Historico: 
#
# v1.0 11/11/2024, edgar:
#   - criaçao do script
#
# v1.1 04/03/2025, edgar:
#   - adiçao de update para pacotes em flatpak
#
# v2.0 05/03/2025, edgar:
#   - refatoraçao completa do codigo: add de cabeçalho, funçoes, ajuda, verificaçao de comandos, etc
#   - implementaçao de modo silencioso e listagem de pacotes atualizados
# v2.1 12/11/2025, edgar:
#   - adiçao de spinner animado no modo silencioso
#
#-------variaveis-------#

BANNER=cat << "EOF"
     _____            __                    __  __          __      __     
    / ___/__  _______/ /____  ____ ___     / / / /___  ____/ /___ _/ /____ 
    \__ \/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \ 
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/
  /____/\__, /____/\__/\___/_/ /_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/ 
       /____/                                /_/                           
 
EOF

MENSAGEM_USO="

    $(basename $0) - [OPÇOES]
    
    -h - ajuda
    -v - versao
    -q - modo silencioso
    
"
VERSAO="v2.1"
DEFAULT=0
SILENCIOSO=0

#----------------------#

#-------testes-------#

# Instala o yay (se não estiver instalado)
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
    	executar "sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm" "[1/2] Atualizando pacotes pacman"
		executar "yay -Syu --noconfirm && yay -Sc --noconfirm" "[2/2] Atualizando pacotes do AUR"
	
	else
		echo $BANNER
        sudo pacman -Syu --noconfirm
        sudo pacman -Sc --noconfirm
        yay -Syu --noconfirm
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

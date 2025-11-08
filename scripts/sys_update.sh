#!/usr/bin/env bash

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
#
#-------variaveis-------#

MENSAGEM_USO="

    $(basename $0) - [OPÇOES]
    
    -h - ajuda
    -v - versao
    -q - modo silencioso
    
"
VERSAO="v2.0"
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

# verifica Flatpak
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak não está instalado. Pulando atualização."
fi

#--------------------#

#-------funçoes-------#

crontab () {
    # Instala o cronie (cron para Arch Linux) e inicia o serviço
    sudo pacman -S --noconfirm cronie
    sudo systemctl enable cronie
    sudo systemctl start cronie

    # Agenda a tarefa cron para rodar a cada três dias à meia-noite
    (crontab -l ; echo "12 0 */3 * * ~/sys_update.sh") | crontab -

    echo "Configuração concluída. O sistema será atualizado automaticamente a cada três dias."
}

atualiza () {
    if [[ $SILENCIOSO -eq 1 ]]; then
        sudo pacman -Syu --quiet --noconfirm
        sudo pacman -Sc --quiet --noconfirm
        yay -Syu --quiet --noconfirm
        flatpak update -y
    else
        sudo pacman -Syu --noconfirm
        sudo pacman -Sc --noconfirm
        yay -Syu --noconfirm
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

[ $DEFAULT -eq 1 ] && atualiza | crontab
#----------------------#

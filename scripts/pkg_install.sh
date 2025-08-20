#!/bin/bash

# Script: pkg_install.sh
# Descrição: Instala pacotes baseado em arquivo de configuração
# Uso: ./pkg_install.sh arquivo_config.txt

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para instalar pacotes do Pacman
install_pacman() {
    if [ ${#PACMAN_PKGS[@]} -eq 0 ]; then
        print_status "Nenhum pacote do Pacman para instalar."
        return
    fi
    
    print_status "Instalando pacotes do Pacman: ${PACMAN_PKGS[*]}"
    sudo pacman -S --noconfirm "${PACMAN_PKGS[@]}"
    if [ $? -eq 0 ]; then
        print_success "Pacotes do Pacman instalados com sucesso!"
    else
        print_error "Falha ao instalar alguns pacotes do Pacman."
    fi
}

# Função para instalar pacotes do AUR (usando yay)
install_aur() {
    if [ ${#AUR_PKGS[@]} -eq 0 ]; then
        print_status "Nenhum pacote do AUR para instalar."
        return
    fi
    
    # Verificar se yay está instalado
    if ! command_exists yay; then
        print_status "yay não encontrado. Instalando yay primeiro..."
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm && cd -
    fi
    
    print_status "Instalando pacotes do AUR: ${AUR_PKGS[*]}"
    yay -S --noconfirm "${AUR_PKGS[@]}"
    if [ $? -eq 0 ]; then
        print_success "Pacotes do AUR instalados com sucesso!"
    else
        print_error "Falha ao instalar alguns pacotes do AUR."
    fi
}

# Função para instalar pacotes do Flatpak
install_flatpak() {
    if [ ${#FLATPAK_PKGS[@]} -eq 0 ]; then
        print_status "Nenhum pacote do Flatpak para instalar."
        return
    fi
    
    # Verificar se flatpak está instalado
    if ! command_exists flatpak; then
        print_status "Flatpak não encontrado. Instalando flatpak primeiro..."
        sudo pacman -S --noconfirm flatpak
    fi
    
    # Adicionar repositório Flathub se necessário
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    print_status "Instalando pacotes do Flatpak: ${FLATPAK_PKGS[*]}"
    flatpak install -y flathub "${FLATPAK_PKGS[@]}"
    if [ $? -eq 0 ]; then
        print_success "Pacotes do Flatpak instalados com sucesso!"
    else
        print_error "Falha ao instalar alguns pacotes do Flatpak."
    fi
}

# Função principal
main() {
    # Verificar se o arquivo de configuração foi fornecido
    if [ $# -eq 0 ]; then
        print_error "Por favor, forneça o arquivo de configuração como argumento."
        echo "Uso: $0 arquivo_config.txt"
        exit 1
    fi

    CONFIG_FILE="$1"
    
    # Verificar se o arquivo existe
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Arquivo de configuração '$CONFIG_FILE' não encontrado!"
        exit 1
    fi

    # Arrays para armazenar os pacotes
    declare -a PACMAN_PKGS
    declare -a AUR_PKGS
    declare -a FLATPAK_PKGS

    # Variável para controlar a seção atual
    current_section=""

    # Ler o arquivo de configuração
    while IFS= read -r line; do
        # Remover espaços em branco no início e fim
        line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')
        
        # Pular linhas vazias e comentários
        if [[ -z "$line" || "$line" =~ ^# ]]; then
            continue
        fi
        
        # Verificar se é uma nova seção
        if [[ "$line" =~ ^[a-zA-Z_]+.*\{ ]]; then
            current_section=$(echo "$line" | awk '{print $1}')
            continue
        fi
        
        # Verificar fim de seção
        if [[ "$line" == "}" ]]; then
            current_section=""
            continue
        fi
        
        # Adicionar pacotes à seção apropriada
        case $current_section in
            "pacman")
                PACMAN_PKGS+=("$line")
                ;;
            "aur")
                AUR_PKGS+=("$line")
                ;;
            "flatpak")
                FLATPAK_PKGS+=("$line")
                ;;
        esac
    done < "$CONFIG_FILE"

    # Mostrar resumo do que será instalado
    echo ""
    print_status "=== RESUMO DE INSTALAÇÃO ==="
    print_status "Pacman: ${PACMAN_PKGS[*]}"
    print_status "AUR: ${AUR_PKGS[*]}"
    print_status "Flatpak: ${FLATPAK_PKGS[*]}"
    echo ""

    # Confirmar com o usuário
    read -p "Deseja prosseguir com a instalação? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_status "Instalação cancelada."
        exit 0
    fi

    # Instalar os pacotes
    install_pacman
    install_aur
    install_flatpak

    print_success "Processo de instalação concluído!"
}

# Executar função principal
main "$@"

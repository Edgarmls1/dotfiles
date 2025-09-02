#!/bin/bash

set -e 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

create_backup() {
    local file_path="$1"
    if [ -e "$file_path" ]; then
        local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$file_path" "$backup_path"
        log_warning "Backup criado: $backup_path"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        create_backup "$target"
    fi
    
    ln -sf "$source" "$target"
    log_success "Symlink criado: $target -> $source"
}

install_dotfiles() {
    local dotfiles_dir="$1"
    local config_dir="$HOME/.config"
    
    log_info "Iniciando instalação dos dotfiles..."
    log_info "Diretório dos dotfiles: $dotfiles_dir"
    log_info "Diretório de configuração: $config_dir"
    
    if [ ! -d "$dotfiles_dir" ]; then
        log_error "Diretório de dotfiles não encontrado: $dotfiles_dir"
        exit 1
    fi
    
    mkdir -p "$config_dir"
    
    local ignore_list=("." ".." ".git" ".gitignore" "README.md" "install.sh")
    
    for item in "$dotfiles_dir"/*; do
        if [ ! -e "$item" ]; then
            continue
        fi
        
        local basename=$(basename "$item")
        local skip=false
        
        for ignore_item in "${ignore_list[@]}"; do
            if [ "$basename" == "$ignore_item" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = true ]; then
            log_info "Ignorando: $basename"
            continue
        fi
        
        local target_path="$config_dir/$basename"
        create_symlink "$item" "$target_path"
    done
    
    log_success "Instalação dos dotfiles concluída!"
}

show_help() {
    cat << EOF
Uso: $0 [OPÇÕES] [DIRETÓRIO_DOTFILES]

Script para instalação automática de dotfiles na pasta ~/.config

OPÇÕES:
    -h, --help          Mostra esta ajuda
    -b, --backup-only   Apenas cria backup dos arquivos existentes
    -f, --force         Força a instalação sem confirmação
    -d, --dry-run       Simula a instalação sem fazer alterações

EXEMPLOS:
    $0 ~/dotfiles
    $0 --force ~/meus-dotfiles
    $0 --dry-run .

Se nenhum diretório for especificado, usa o diretório atual.
EOF
}

dry_run() {
    local dotfiles_dir="$1"
    local config_dir="$HOME/.config"
    
    log_info "=== SIMULAÇÃO DE INSTALAÇÃO ==="
    log_info "Diretório dos dotfiles: $dotfiles_dir"
    log_info "Diretório de configuração: $config_dir"
    
    local ignore_list=("." ".." ".git" ".gitignore" "README.md" "install.sh")
    
    for item in "$dotfiles_dir"/*; do
        if [ ! -e "$item" ]; then
            continue
        fi
        
        local basename=$(basename "$item")
        local skip=false
        
        for ignore_item in "${ignore_list[@]}"; do
            if [ "$basename" == "$ignore_item" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = true ]; then
            continue
        fi
        
        local target_path="$config_dir/$basename"
        
        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
            echo "BACKUP: $target_path"
        fi
        echo "SYMLINK: $target_path -> $item"
    done
    
    log_info "=== FIM DA SIMULAÇÃO ==="
}

DOTFILES_DIR=""
FORCE=false
DRY_RUN=false
BACKUP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -b|--backup-only)
            BACKUP_ONLY=true
            shift
            ;;
        -*)
            log_error "Opção desconhecida: $1"
            show_help
            exit 1
            ;;
        *)
            DOTFILES_DIR="$1"
            shift
            ;;
    esac
done

if [ -z "$DOTFILES_DIR" ]; then
    DOTFILES_DIR="$(pwd)"
fi

DOTFILES_DIR="$(realpath "$DOTFILES_DIR")"

if [ "$DRY_RUN" = true ]; then
    dry_run "$DOTFILES_DIR"
    exit 0
fi

if [ "$FORCE" = false ]; then
    echo
    log_info "Configurações:"
    echo "  Dotfiles: $DOTFILES_DIR"
    echo "  Destino: $HOME/.config"
    echo
    read -p "Deseja continuar? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        log_info "Instalação cancelada pelo usuário."
        exit 0
    fi
fi

install_dotfiles "$DOTFILES_DIR"

echo
log_success "Processo concluído! Seus dotfiles estão instalados em ~/.config"
log_info "Para aplicar as configurações, reinicie os aplicativos ou faça logout/login."

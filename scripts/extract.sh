#!/usr/bin/env bash
set -euo pipefail

# Uso: ./extract.sh <pasta> <prefixo> <quantidade> [extensao]
# Ex.:  ./extract.sh ./downloads parte 12 zip
#       ./extract.sh ./downloads parte 12 tar.gz

WHERE_IS="${1:?Uso: $0 <pasta> <prefixo> <quantidade> [extensao=zip]}"
PATTERN="${2:?Prefixo dos arquivos obrigatorio}"
FILES_QNT="${3:?Quantidade de arquivos obrigatoria}"
EXT="${4:-zip}"

check_and_install_7zip() {
    if command -v 7z &>/dev/null || command -v 7zz &>/dev/null; then
        return 0
    fi

    echo "7-Zip não encontrado. Instalando..."

    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm p7zip
    elif command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y p7zip-full
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y p7zip p7zip-plugins
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y p7zip-full
    elif command -v apk &>/dev/null; then
        sudo apk add p7zip
    else
        echo "Gerenciador de pacotes não reconhecido. Instale o 7-Zip manualmente." >&2
        exit 1
    fi
}

extract_one() {
    local file="$1"
    local ext="$2"

    case "$ext" in
        tar.gz|tgz)
            tar -xzf "$file"
            ;;
        rar)
            if command -v unrar &>/dev/null; then
                unrar x -o+ "$file"
            else
                7z x "$file" -y
            fi
            ;;
        *)
            7z x "$file" -y
            ;;
    esac
}

check_and_install_7zip

cd "$WHERE_IS"

for ((n = 1; n <= FILES_QNT; n++)); do
    file=$(printf "%s%03d.%s" "$PATTERN" "$n" "$EXT")

    if [ ! -f "$file" ]; then
        echo "Aviso: '$file' não encontrado, pulando." >&2
        continue
    fi

    echo "Extraindo: $file"
    if extract_one "$file" "$EXT"; then
        rm -- "$file"
    else
        echo "Erro ao extrair '$file'. Arquivo mantido." >&2
    fi
done

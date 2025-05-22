#!/bin/bash

while true; do
    # Testa o ping para o Google (8.8.8.8) e extrai o tempo médio de resposta
    ping_result=$(ping -c 1 -W 1 8.8.8.8 | awk -F'/' '/rtt/ {print $5}')

    # Se o ping não retornou nada, define como "Offline"
    if [[ -z "$ping_result" ]]; then
        icon="󰤯"  # Ícone de desconectado
        ping_result="Offline"
    else
        # Remove possíveis espaços e converte o ping para número inteiro corretamente
        ping_ms=$(echo "$ping_result" | awk '{printf "%.0f", $1}')

        # Define o ícone baseado na latência
        if (( ping_ms < 50 )); then
            icon="󰤨"  # Boa conexão
        elif (( ping_ms < 100 )); then
            icon="󰤥"  # Conexão média
        else
            icon="󰤢"  # Conexão ruim
        fi
    fi

    # Saída formatada para a Waybar
    echo "{\"text\": \"$icon $ping_result ms\", \"tooltip\": \"Qualidade da Conexão: $ping_result ms\"}"

    # Atualiza a cada 5 segundos
    sleep 5
done

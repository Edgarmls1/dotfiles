#!/bin/bash

num_re='^-?[0-9]+([.][0-9]+)?$'
expressao=""

for ((idx=1; idx<=$#; idx++)); do
    arg="${!idx}"

    if [ $(( idx % 2 )) -eq 1 ]; then
        if ! [[ $arg =~ $num_re ]]; then
            echo "Erro: '$arg' não é um número válido."
            exit 1
        fi
        expressao+="$arg"
    else
        case "$arg" in
            +|-|/|%|^) expressao+=" $arg " ;;
            "*"|x) expressao+=" * " ;;
            *)
                echo "Erro: operador '$arg' não reconhecido. Use + - * / % ^"
                exit 1
                ;;
        esac
    fi
done

if echo "$expressao" | grep -Eq '/ *0([^.0-9]|$)'; then
    echo "Erro: divisão por zero."
    exit 1
fi

resultado=$(echo "scale=4; $expressao" | bc -l)

resultado=$(echo "$resultado" | sed -E 's/(\.[0-9]*[1-9])0+$/\1/; s/\.0+$//')

echo "$resultado"

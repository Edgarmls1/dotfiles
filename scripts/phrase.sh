#!/bin/bash

# replace with your favorite phrases
phrase_list=(
    "Memento Mori"
    "Todo mundo que é minimamente politizado sabe que o funk paulista é um braço do neoliberalismo na américa latina" 
    "Já Bora" 
    "Reginaldo, hora do lanche" 
    "Agora que pulou só falta voar" 
    "Na minha vez o pato grita" 
    "Teu problema é outro" 
    "se ela fosse a mulher do tempo quando vc assiste a TV e voce fosse assistir e sem saber, tivesse que voltar, mas por 1 milhão de reais voce deixaria usar ou ia embora?"
    "Só sobrou cabelo e dente"
    "Ih patrão! quando eu cheguei já tava assim!"
    "Ginga e fala gíria, gíria não, dialéto"
    "Falar gíria bem até papagaio aprende"
    "Traz o gordo e o cabeçudo"
    "Tem que seguir o rato pra achar o queijo"
    "Sou puta e quero dar"
    "Ai não tem persa que aguente"
    "eu sou um diabo necessario"
    "Eu não quero saber de quem é o velorio, eu só quero chorar"
    "Teu pai é um covarde, tu mãe é uma piranha"
    "Na proxima, vou-me embora para Pasárgada"
    "Jabor Sabora"
    "Prossiga com o plano 9"
    "Se passarinho mamasse não aprendia a voar"
    "Esse ai até quem é cego ouviu direitinho"
    "Com quantos anos você nasceu?"
    "Se raspou de um lado tem que raspar do outro"
    ""
)

phrase=$(( $RANDOM % ${#phrase_list[@]} ))

echo "${phrase_list[phrase]}"

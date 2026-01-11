#! /bin/bash

menu() {
    clear
    echo "++================================++"
    echo "|| 1) clean (navegador e spotify) ||"
    echo "|| 2) games                       ||"
    echo "|| 3) dev                         ||"
    echo "|| 0) sair                        ||"
    echo "++================================++"
    read -p " " choice

    case $choice in
        1) clean                                                    ;;
        2) games                                                    ;;
        3) dev                                                      ;;
        0) exit 0                                                   ;;
        *) echo "Opção inválida. Tente novamente." ; sleep 1 ; menu ;;
    esac
}

clean() {
    clear
    echo "+-------------------------+"
    echo "| instalando config clean |"
    echo "+-------------------------+"

    yay -S spotify spicetify-cli

    echo ""
    echo "qual navegador deseja instalar?"
    echo "1 - zen"
    echo "2 - chrome"
    echo "3 - firefox"
    echo "4 - brave"
    echo "5 - todos"
    echo "0 - nenhum"
    read -p " " choice

    case $choice in 
        1) yay -S zen-browser-bin ;;
        2) yay -S google-chrome                        ;;
        3) sudo pacman -S firefox                      ;;
        4) yay -S brave-bin                            ;;
        5) 
            yay -S google-chrome brave-bin zen-browser-bin
            sudo pacman -S firefox
        ;;
        0) " "                                         ;;
        *) "opcao invalida"                            ;;
    esac


    ask_to_continue
}

games() {
    clear
    echo "+----------------------------+"
    echo "| instalando config p/ games |"
    echo "+----------------------------+"

    yay -S hydra-launcher-bin faugus-launcher heoric-games-launcher-bin
    sudo pacman -S steam retroarch discord

    echo "+---------------------------------------+"
    echo "| config p/ games instalada com sucesso |"
    echo "+---------------------------------------+"

    ask_to_continue
}

dev() {
    clear
    echo "+--------------------------+"
    echo "| instalando config p/ dev |"
    echo "+--------------------------+"

    sudo pacman -S neovim obsidian bitwarden
    yay -S visual-studio-code-bin

    read -p "Deseja instalar o java? (s/N)" java

    case $java in
        [Ss]*)
            sudo pacman -S jdk-openjdk
        ;;
        *) "" ;;
    esac

    echo " "
    echo "para instalar bibliotecas python basta digitar por exemplo 'sudo pacman -S pyhton-pandas'"
    echo " "

    echo "+-------------------------------------+"
    echo "| config p/ dev instalada com sucesso |"
    echo "+-------------------------------------+"

    ask_to_continue
}

ask_to_continue() {
    echo ""
    read -p "Deseja realizar outra operação? (s/N) " resp
    
    case $resp in
        [Ss]*) menu                             ;;
        *) echo "instalaçao concluida" ; exit 0 ;;
    esac
}

menu

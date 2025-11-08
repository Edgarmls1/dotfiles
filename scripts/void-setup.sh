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

    flatpak install flathub com.spotify.Client

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
        1) flatpak install flathub app.zen_browser.zen ;;
        2) flatpak install flathub com.google.Chrome   ;;
        3) sudo xbps-install firefox                   ;;
        4) flatpak install flathub com.brave.Browser   ;;
        5) 
            flatpak install flathub brave chrome zen
            sudo xbps-install firefox
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

    sudo xbps-install steam retroarch
	flatpak install flathub com.discordapp.Discord io.github.Faugus.faugus-launcher

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

	flatpak install flathub md.obsidian.Obsidian com.visualstudio.code com.bitwarden.desktop
    sudo xbps-install neovim

    read -p "Deseja instalar o java? (s/N)" java

    case $java in
        [Ss]*)
            sudo xbps-install openjdk
        ;;
        *) "" ;;
    esac

    echo " "
    echo "para instalar bibliotecas python basta digitar por exemplo 'sudo xbps-install python3-pandas'"
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

sudo xbps-install -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

menu

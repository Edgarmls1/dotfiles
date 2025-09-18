#! /usr/bin/bash

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

    yay -S spotify

    echo ""
    read -p "deseja instalar o spicetify? (s/N)" choice

    case $choice in 
        [Ss]*) 
            yay -S spicetify-cli
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R
            spicetify backup apply
            curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
        ;;
        *) "" ;;
    esac
    
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
        2) yay -S google-chrome                        ;;
        3) sudo pacman -S firefox                      ;;
        4) yay -S brave-bin                            ;;
        5) 
            flatpak install flathub app.zen_browser.zen 
            yay -S google-chrome brave-bin
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

    yay -S heroic-games-launcher-bin hydra-launcher-bin
    sudo pacman -S steam
    flatpak install flathub net.lutris.Lutris org.libretro.RetroArch com.discordapp.Discord

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

    sudo pacman -S neovim ttf-jetbrains-mono-nerd
    yay -S visual-studio-code-bin
    flatpak install flathub md.obsidian.Obsidian

    read -p "Deseja instalar o java? (s/N)" java

    case $java in
        [Ss]*)
            sudo pacman -S jdk-openjdk
        ;;
        *) "" ;;
    esac

    read -p "Deseja instalar postgres? (s/N)" pgsql

    case $pgsql in 
        [Ss]*) 
            sudo pacman -S postgresql
            yay -S pgadmin4-desktop

            cd /usr/pgadmin4/venv/bin
            sudo rm python3
            sudo ln $(which python3) python3
            cd
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

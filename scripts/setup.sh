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
    flatpak install flathub com.valvesoftware.Steam net.lutris.Lutris org.libretro.RetroArch com.discordapp.Discord

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

    sudo pacman -S neovim zsh ttf-jetbrains-mono-nerd
    yay -S visual-studio-code-bin
    flatpak install flathub md.obsidian.Obsidian

    usermod -s $(which zsh) $(whoami)

    read -p "Deseja instalar postgres? (s/N)" choice2

    case $choice2 in 
        [Ss]*) 
            sudo pacman -S postgresql
            yay -S pgadmin4-desktop

            cd /usr/pgadmin4/venv/bin
            sudo rm python3
            sudo ln ~/anaconda3/bin/python3.12 python3
            cd
        ;;
        *) "" ;;
    esac

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

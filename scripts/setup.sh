#! /bin/bash

menu() {
    clear
    echo "++===========++"
    echo "|| 1) clean  ||"
    echo "|| 2) games  ||"
    echo "|| 3) dev    ||"
    echo "|| 0) exit   ||"
    echo "++===========++"
    read -p " " choice

    case $choice in
        1) clean                                                    ;;
        2) games                                                    ;;
        3) dev                                                      ;;
        0) 
			echo "Your system will reboot in 5 seconds...\n"
			for i in $(seq 5 -1 1); do
				printf "$i"
				sleep 0.3
				printf "."
				sleep 0.3
				printf "."
				sleep 0.3
				printf "."
				sleep 0.1
			done
			printf "\n"
			shutdown -r now 
		;;
        *) 
			echo "Invalid option."
			sleep 1
			menu 
		;;
    esac
}

clean() {
    clear
    echo "+------------------------+"
    echo "| instaling clean config |"
    echo "+------------------------+"

    yay -S spotify spicetify-cli

    echo ""
    echo "which web browser do you want?"
    echo "1 - zen"
    echo "2 - chrome"
    echo "3 - firefox"
    echo "4 - helium"
    echo "5 - all"
    echo "0 - none"
    read -p " " choice

    case $choice in 
        1) yay -S zen-browser-bin        ;;
        2) yay -S google-chrome          ;;
        3) yay -S firefox                ;;
        4) yay -S helium-browser-bin     ;;
        5) 
            yay -S google-chrome \
			       helium-browser-bin \
				   zen-browser-bin \
				   firefox
        ;;
        0) " "                           ;;
        *) "invalid option"              ;;
    esac


    ask_to_continue
}

games() {
    clear
    echo "+-------------------------+"
    echo "| instaling gaming config |"
    echo "+-------------------------+"

    yay -S hydra-launcher-bin faugus-launcher heoric-games-launcher-bin steam retroarch discord element-desktop

    ask_to_continue
}

dev() {
    clear
    echo "+----------------------------+"
    echo "| instaling developer config |"
    echo "+----------------------------+"

    yay -S neovim obsidian bitwarden vscodium virtualbox

	sudo modprobe vboxdrv
	sudo usermod -aG vboxusers $USER

    read -p "Do you want to install java? (y/N)" java

    case $java in
        [Yy]*)
            yay -S jdk-openjdk
        ;;
        *) "" ;;
    esac

    ask_to_continue
}

ask_to_continue() {
    echo ""
	read -p "Do you want to install another config? (y/N)" choice
    
    case $choice in
        [Yy]*) menu                              ;;
        *) echo "instalation completed" ; exit 0 ;;
    esac
}

menu

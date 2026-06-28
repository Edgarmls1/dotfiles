#! /bin/bash

reboot() {
	clear
	read -p "Do you want to reboot your system? [y/N] " reboot
	
	case $reboot in
		[Yy]*)
			echo "Your system will reboot in 5 seconds..."
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
	esac
}

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
        1) clean  ;;
        2) games  ;;
        3) dev    ;;
        0) reboot ;;
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

	echo ""
    echo "+------------------------------------------+"
	echo "| This option will install in your system: |"
	echo "| a web browser                            |"
	echo "| spotify                                  |"
    echo "+------------------------------------------+"
	echo ""
	read -p "Do you want to continue? [y/N] " agree
	
	case $agree in
		[Yy]*)
			echo ""
			echo "which web browser do you want?"
			echo "1 - zen"
			echo "2 - chrome"
			echo "3 - firefox"
			echo "4 - all"
			echo "0 - none"
			read -p " " choice

			case $choice in 
				1) yay -S --noconfirm zen-browser-bin ;;
				2) yay -S --noconfirm google-chrome   ;;
				3) yay -S --noconfirm firefox         ;;
				4) 
					yay -S --noconfirm zen-browser-bin \
					   	google-chrome \
					   	firefox
					;;
				0) " "                           ;;
				*) "invalid option"              ;;
			esac
            yay -S --noconfirm spotify
	esac
    ask_to_continue
}

games() {
    clear
    echo "+-------------------------+"
    echo "| instaling gaming config |"
    echo "+-------------------------+"

	echo ""
    echo "+------------------------------------------+"
	echo "| This option will install in your system: |"
	echo "| - steam                                  |"
	echo "| - retroarch                              |"
	echo "| - discord                                |"
	echo "| - heroic (epic client)                   |"
	echo "| - faugus                                 |"
	echo "| - trinity launcher (minecraft)           |"
    echo "+------------------------------------------+"
	echo ""
	read -p "Do you want to continue? [y/N] " agree
	
	case $agree in
		[Yy]*)
			echo ""
			yay -S faugus-launcher heoric-games-launcher-bin steam retroarch discord
			flatpak remote-delete trinity
			flatpak remote-add trinity https://github.com/Trinity-LA/Trinity-Launcher/releases/download/flatpak/com.trench.trinity.launcher.flatpakrepo
			flatpak install com.trench.trinity.launcher org.vinegarhq.Sober
	esac

    ask_to_continue
}

dev() {
    clear
    echo "+----------------------------+"
    echo "| instaling developer config |"
    echo "+----------------------------+"

	echo ""
    echo "+------------------------------------------+"
	echo "| This option will install in your system: |"
	echo "| - neovim                                 |"
	echo "| - obsidian                               |"
	echo "| - bitwarden                              |"
	echo "| - vscode                                 |"
	echo "| - zed                                    |"
	echo "| - virtualbox                             |"
	echo "| - java                                   |"
    echo "+------------------------------------------+"
	echo ""
	read -p "Do you want to continue? [y/N] " agree

	case $agree in
		[Yy]*)
			echo ""
			yay -S --noconfirm neovim bitwarden visual-studio-code-bin virtualbox zed

			sudo modprobe vboxdrv
			sudo usermod -aG vboxusers $USER

			read -p "Do you want to install java? (y/N)" java

			case $java in
				[Yy]*)
					yay -S --noconfirm jdk-openjdk
					;;
				*) "" ;;
			esac
	esac

    ask_to_continue
}

ask_to_continue() {
    echo ""
	read -p "Do you want to install another config? (y/N)" choice
    
    case $choice in
        [Yy]*) menu                              ;;
        *) echo "instalation completed" ; reboot ;;
    esac
}

menu

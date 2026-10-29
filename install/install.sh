#!/bin/bash
sudo sed -i -E "s|#VerbosePkgLists|VerbosePkgLists\nDisableDownloadTimeout|g" /etc/pacman.conf 2> /dev/null
sudo sed -i -E "s|ParallelDownloads = 5|ParallelDownloads = 10|g" /etc/pacman.conf 2> /dev/null
sudo pacman -Syy
sudo pacman -S python-textual
if ! command -v yay &> /dev/null; then
    sudo pacman -S git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi
exec "$(dirname "${BASH_SOURCE[0]}")/tui.py"

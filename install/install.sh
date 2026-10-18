#!/bin/bash
sudo sed -i -E "s|#VerboseOkgList|VerboseOkgList\nDisableDownloadTimeout|g" /etc/pacman.conf 2> /dev/null
sudo sed -i -E "s|ParallelDownloads = 5|ParallelDownloads = 10|g" /etc/pacman.conf 2> /dev/null
sudo pacman -Syy
sudo pacman -S python-textual
exec "$(dirname "${BASH_SOURCE[0]}")/tui.py"

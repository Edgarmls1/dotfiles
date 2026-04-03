export BASH_COMPLETION_COMPAT_DIR="/usr/share/bash-completion/completions"

HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=" *"
shopt -s histappend
shopt -s histverify
export PROMPT_COMMAND="history -a; history -c; history -r"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

shopt -s autocd 2>/dev/null || true

shopt -s cdspell
shopt -s dirspell

PROMPT_COLOR="32" # green

prompt_color(){
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="32" # green
    else
        PROMPT_COLOR="31" # red
    fi
}

PROMPT_COMMAND="prompt_color; $PROMPT_COMMAND"
PS1='\n\[\e[0;${PROMPT_COLOR}m\]\w\[\e[0m\] \n\[\e[0;${PROMPT_COLOR}m\]\u@\h > \[\e[0m\]'

alias l='lsd'
alias la='lsd -a'
alias :q="exit"
alias cc="cd ~ && clear"
alias up="~/dotfiles/scripts/update.sh"
alias pi="sudo pacman -S"
alias pr="sudo pacman -Rs"
alias yi="yay -S"
alias yr="yay -Rs"
alias s="yay -Ss"
alias n="nvim"
alias py="~/pyenv/bin/python"
alias hypr="nvim ~/.config/hypr/hyprland.conf"
alias faci="cd ~/dev/faci/"
alias notes="nvim ~/dev/cofre/"
alias c="cd"

export EDITOR="nvim"

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function f() {
	nvim "$(fzf --style full --preview "bat --color=always {}")"
}

source -- ~/.local/share/blesh/ble.sh
source ~/pyenv/bin/activate
export PATH=$PATH:/home/edgar/.spicetify
fastfetch

#
# ~/.bashrc
#

GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'

export PS1="\w\n${GREEN}${USER}@${HOSTNAME} > "
trap 'echo -ne "\e[0;32m"' DEBUG

source ~/anaconda3/bin/activate

alias update="~/sys_update.sh"
alias ls="lsd"
alias lsa="lsd -a"
alias ..="cd .."
alias gcs="google-chrome-stable"
alias :q="exit"

export EDITOR="nvim"

function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"

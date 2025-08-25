export ZSH_DISABLE_COMPFIX=true

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

setopt CORRECT
setopt CORRECT_ALL

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

PROMPT_COLOR="green"

prompt_color(){
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="green"
    else
        PROMPT_COLOR="red"
    fi
}

autoload -U colors && colors
setopt PROMPT_SUBST
PS1=$'%F{$PROMPT_COLOR}%~%f \n%F{$PROMPT_COLOR}%n@%m > %f'

alias ls='lsd'
alias lsa='lsd -a'
alias update='~/sys_update.sh'
alias reconfig='p10k configure'
alias ..="cd .."
alias :q="exit"
alias cc="cd ~ && clear"

eval "$(fzf --zsh)"

export EDITOR="nvim"

function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/anaconda3/bin/activate

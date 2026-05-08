ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

date
~/dotfiles/scripts/pokemon.sh

autoload -U colors && colors
setopt PROMPT_SUBST

PROMPT_COLOR="green"
PORJECT=" "

precmd() {
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="green"
    else
        PROMPT_COLOR="red"
    fi

	project
}

project() {
    PROJECT=""

    if [[ -d ".git" ]]; then
        PROJECT+=" "
    fi
    
    if ls -A | grep -iq "docker"; then
        PROJECT+=" 󰡨"
    fi
    
    if [[ "${(L)PWD}" == *"py"* ]] || ls -A | grep -q '\.py$'; then
        PROJECT+=" 󰌠"
    fi    
    
    if [[ "${(L)PWD}" == *"java"* ]] || ls -A | grep -q '\.java$'; then
        PROJECT+=" "
    fi

    if [[ "${(L)PWD}" == *"go"* ]] || ls -A | grep -q '\.go$'; then
        PROJECT+=" "
    fi

    if [[ "${(L)PWD}" == *"rust"* ]] || ls -A | grep -q '\.rs$'; then
        PROJECT+=" "
    fi
}

PS1=$'\n%F{$PROMPT_COLOR}%~%f\n%F{$PROMPT_COLOR}$USER@$HOST${PROJECT} > %f'

export EDITOR="nvim"

export PATH=$PATH:/home/edgar/.spicetify:/home/edgar/.local/bin

alias code="codium"

alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

alias ls="lsd"
alias ..="cd .."
alias :q="exit"
alias :wq="exit"
alias cc="cd && clear"

alias update="~/dotfiles/scripts/update.sh"

alias python="~/pyenv/bin/python"

alias hyprc="nvim ~/.config/hypr/hyprland.conf"

alias weather="curl wttr.in"

alias faci="cd ~/dev/faci/"
alias notes="nvim ~/dev/notes/"
alias update-notes="cd ~/dev/notes/ ; git add . ; git commit -m 'notes update' ; git push ; cd -"

alias -g fastfetchc="~/.config/fastfetch/"
alias -g nvimc="~/.config/nvim/"
alias -g hyprconf="~/.config/hypr/"
alias -g kittyc="~/dotfiles/kitty/"
alias -g waybarc="~/.config/waybar/"
alias -g scripts="~/dotfiles/scripts/"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

emulate bash -c "source ~/pyenv/bin/activate"

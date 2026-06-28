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

precmd() {
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="green"
    else
        PROMPT_COLOR="red"
    fi
}

f() {
	nvim "$(fzf --style full --preview "bat --color=always {}")"
}

PS1=$'\n%F{$PROMPT_COLOR}%~%f\n%F{$PROMPT_COLOR}$USER@$HOST > %f'

export EDITOR="nvim"

export PATH=$PATH:/home/edgar/.spicetify:/home/edgar/.local/bin

alias ls="lsd"
alias ..="cd .."
alias :q="exit"
alias :wq="exit"
alias cc="cd && clear"
alias hist="history -100 | grep --color=auto"
alias grep="grep --color=auto"

alias update="~/dotfiles/scripts/update.sh"
alias check-updates="~/dotfiles/scripts/update.sh -c"
alias extract="~/dotfiles/scripts/extract.sh"

alias python="~/pyenv/bin/python"

alias hyprc="nvim ~/.config/hypr/hyprland.lua"

alias weather="curl wttr.in"

alias faci="cd ~/dev/faci/"
alias notes="nvim ~/notes/"

alias update-notes="cd ~/notes/ ; git add . ; git commit -m 'notes update' ; git push ; cd -"
alias update-dev="cd ~/dev/ ; git add . ; git commit -m 'projects update' ; git push ; cd -"
alias pull-notes="cd ~/notes/ ; git pull"
alias pull-dev="cd ~/dev/ ; git pull"

alias -g fastfetchc="~/.config/fastfetch/"
alias -g nvimc="~/.config/nvim/"
alias -g hyprconf="~/.config/hypr/"
alias -g kittyc="~/.config/kitty/"
alias -g waybarc="~/.config/waybar/"
alias -g scripts="~/dotfiles/scripts/"

eval "$(fzf --zsh)"

emulate bash -c "source ~/pyenv/bin/activate"

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

PS1=$'\n%F{$PROMPT_COLOR}%~%f\n%F{$PROMPT_COLOR}󰣇 > %f'

export EDITOR="nvim"

export PATH=$PATH:/home/edgar/.spicetify

alias ls="lsd"
alias cat="bat"
alias :q="exit"
alias :wq="exit"
alias cc="cd $HOME && clear"

alias update="$HOME/dotfiles/scripts/update.sh"

alias python="$HOME/pyenv/bin/python"

alias hyprc="nvim $HOME/.config/hypr/hyprland.conf"

alias faci="cd $HOME/dev/faci/"
alias notes="nvim $HOME/dev/notes/"

emulate bash -c "source $HOME/pyenv/bin/activate"

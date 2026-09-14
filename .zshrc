# --- PLUGINS --- #

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

# --- XXXXXXX --- #

# --- FUNCTIONS --- #

autoload -U colors && colors
setopt PROMPT_SUBST
zmodload zsh/datetime

SUDO=""
PROMPT_COLOR="green"
CMD_DURATION=""

preexec() {
    CMD_START=$EPOCHREALTIME
}

precmd() {
    local exit_code=$?

    if (( exit_code == 0 )); then
        PROMPT_COLOR="green"
    else
        PROMPT_COLOR="red"
    fi

    if [[ -n "$CMD_START" ]]; then
        local elapsed=$(( EPOCHREALTIME - CMD_START ))
        if (( elapsed >= 1 )); then
            if (( elapsed >= 60 )); then
                CMD_DURATION=$(printf " (%dm%.0fs)" $(( elapsed / 60 )) $(( elapsed % 60 )))
            else
                CMD_DURATION=$(printf " (%.2fs)" $elapsed)
            fi
        else
            CMD_DURATION=""
        fi
        unset CMD_START
    else
        CMD_DURATION=""
    fi
}

f() {
	nvim "$(fzf --style full --preview "bat --color=always {}")"
}

wallpaper() {
    local hypr_path="$HOME/.config/hypr/hyprpaper.conf"
    local wall_dir="$HOME/dotfiles/wallpapers"

    local paper
    paper=$(ls "$wall_dir" | fzf --preview "kitty +kitten icat '$wall_dir/{}'" --preview-window=right:90%)

    [[ -z "$paper" ]] && return 1

    sed -i -E "s|wallpapers/.*|wallpapers/$paper|g" "$hypr_path"
    pkill hyprpaper
    hyprpaper &
    disown
}

copy() {
    input=$1
    output=$2

    cp -r $input $output | pv > /dev/null
}

move() {
    input=$1
    output=$2

    mv -r $input $output | pv --size $(du -s $input | awk '{print $1}') > /dev/null
}

super() {
    if [[ $PWD != $HOME/* && $PWD != $HOME ]]; then
        SUDO="🔒 "
    else
        SUDO=""
    fi
}

# --- XXXXXXXXX --- #

# --- EXPORTS, SOURCES & ALIASES --- #

export EDITOR="nvim"

export PATH=$PATH:/home/edgar/.spicetify:/home/edgar/.local/bin

alias ls="lsd"
alias ..="cd .."
alias :q="exit"
alias :wq="exit"
alias hist="history -100 | grep --color=auto"
alias grep="grep --color=auto"
alias zed="zeditor"

alias up="~/dotfiles/scripts/update.sh"
alias cup="~/dotfiles/scripts/update.sh -c"
alias extract="~/dotfiles/scripts/extract.sh"
alias calc="~/dotfiles/scripts/calc.sh"

alias py="~/pyenv/bin/python"

alias hyprc="nvim ~/.config/hypr/hyprland.lua"
alias mangoc="nvim ~/.config/mango/config.conf"

alias weather="curl wttr.in"
alias sonin="shutdown +60"

alias faci="cd ~/dev/faci/"
alias notes="nvim ~/notes/"

alias un="cd ~/notes/ ; git add . ; git commit -m 'notes update' ; git push ; cd -"
alias ud="cd ~/dev/ ; git add . ; git commit -m 'projects update' ; git push ; cd -"
alias pn="cd ~/notes/ ; git pull"
alias pd="cd ~/dev/ ; git pull"

alias -g fastfetchc="~/.config/fastfetch/"
alias -g nvimc="~/.config/nvim/"
alias -g hyprconf="~/.config/hypr/"
alias -g kittyc="~/.config/kitty/"
alias -g waybarc="~/.config/waybar/"
alias -g scripts="~/dotfiles/scripts/"

eval "$(fzf --zsh)"

emulate bash -c "source ~/pyenv/bin/activate"

# --- XXXXXXXXXXXXXXXXXXXXXXXXXX --- #

# --- PS1 & EXEC --- #

# if [[ -o interactive ]] && [[ -z "$TMUX" ]]; then
#     tmux kill-session -t main
#     tmux new-session -A -s main
# fi

chpwd_functions+=(super)

super

PS1=$'\n%F{$PROMPT_COLOR}%~%f%F{blue}$CMD_DURATION%f\n%F{$PROMPT_COLOR}${SUDO}> %f'

~/dotfiles/scripts/phrase.sh
~/dotfiles/scripts/pokemon.sh

# --- XXXXXXXXXX --- #


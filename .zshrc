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
setopt autocd
setopt correct

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

autoload -U colors && colors
setopt PROMPT_SUBST
zmodload zsh/datetime

export EDITOR="nvim"

export PATH=$PATH:/home/edgar/.spicetify:/home/edgar/.local/bin:/home/edgar/.config/emacs/bin
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview" # separate opts for history widget

FNM_PATH="/home/edgar/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

source <(fzf --zsh)

emulate bash -c "source ~/pyenv/bin/activate"

SUDO=""
PROMPT_COLOR="green"
CMD_DURATION=""

preexec() { CMD_START=$EPOCHREALTIME }

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

troca() {
    isso=$1
    por=$2
    onde=$3

    sed -i -E "s|$isso|$por|g" "$onde"
}

fuck() { sudo ${(z)$(fc -ln -1)} }

f() { nvim $(fzf) }

super() {
    if [[ $PWD != $HOME/* && $PWD != $HOME ]]; then
        SUDO="🔒 "
    else
        SUDO=""
    fi
}

alias \
\
ls="lsd -lah --group-directories-first" \
mv="mv -iv" \
rm="rm -Iv" \
man="batman" \
y="yazi" \
..="cd .." \
-="cd -" \
:q="exit" \
:wq="exit" \
hist="history -100 | grep --color=auto" \
grep="grep --color=auto" \
cat="bat -l conf -p" \
du="du -sh" \
free="free -h | bat -l conf -p" \
update="~/dotfiles/scripts/update.sh" \
check-updates="~/dotfiles/scripts/update.sh -c" \
extract="~/dotfiles/scripts/extract.sh" \
calc="~/dotfiles/scripts/calc.sh" \
python="~/pyenv/bin/python" \
weather="curl wttr.in" \
sonin="shutdown +60" \
update-notes="cd ~/notes/ ; git add . ; git commit -m 'notes update' ; git push ; cd -" \
update-dev="cd ~/dev/ ; git add . ; git commit -m 'projects update' ; git push ; cd -" \
pull-notes="cd ~/notes/ ; git pull" \
pull-dev="cd ~/dev/ ; git pull"

# if [[ -o interactive ]] && [[ -z "$TMUX" ]]; then
#     tmux kill-session -t main
#     tmux new-session -A -s main
# fi

chpwd_functions+=(super)

super

PS1=$'\n%F{$PROMPT_COLOR}%~%f%F{blue}$CMD_DURATION%f\n%F{$PROMPT_COLOR}${SUDO}> %f'

~/dotfiles/scripts/phrase.sh
echo ""
~/dotfiles/scripts/pokemon.sh

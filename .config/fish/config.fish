set -g fish_greeting

if status is-interactive
    date
    ~/dotfiles/scripts/pokemon.sh

    set -g PROMPT_COLOR green
    set -g CMD_DURATION ""
    set -g LAST_STATUS 0
end

function __cmd_start --on-event fish_preexec
    set -g CMD_START (date +%s.%N)
end

function __cmd_end --on-event fish_postexec
    set -g LAST_STATUS $status

    if set -q CMD_START
        set -l cmd_end (date +%s.%N)
        set -l elapsed (math "$cmd_end - $CMD_START")

        if test $elapsed -ge 1
            if test $elapsed -ge 60
                set -l mins (math --scale=0 "floor($elapsed / 60)")
                set -l secs (math "$elapsed - ($mins * 60)")
                set -g CMD_DURATION (printf " (%dm%.0fs)" $mins $secs)
            else
                set -g CMD_DURATION (printf " (%.2fs)" $elapsed)
            end
        else
            set -g CMD_DURATION ""
        end
        set -e CMD_START
    else
        set -g CMD_DURATION ""
    end
end

function fish_prompt
    if test "$LAST_STATUS" = 0
        set -g PROMPT_COLOR green
    else
        set -g PROMPT_COLOR red
    end

    echo
    set_color $PROMPT_COLOR
    echo -n (string replace -r "^$HOME" "~" -- $PWD)
    set_color normal
    set_color blue
    echo -n "$CMD_DURATION"
    set_color normal
    echo
    set_color $PROMPT_COLOR
    echo -n "$USER@$hostname > "
    set_color normal
end

function f
    nvim (fzf --style full --preview "bat --color=always {}")
end

function wallpaper
    set -l hypr_path "$HOME/.config/hypr/hyprpaper.conf"
    set -l paper $argv[1]

    sed -i -E "s|wallpapers/.*|wallpapers/$paper|g" "$hypr_path"
    pkill hyprpaper
    hyprpaper &
    disown
end

set -gx EDITOR nvim
fish_add_path /home/edgar/.spicetify /home/edgar/.local/bin

alias ls "lsd"
alias .. "cd .."
alias :q "exit"
alias :wq "exit"
alias hist "history --max=100 | grep --color=auto"
alias grep "grep --color=auto"

alias update "~/dotfiles/scripts/update.sh"
alias check-updates "~/dotfiles/scripts/update.sh -c"
alias extract "~/dotfiles/scripts/extract.sh"

alias python "~/pyenv/bin/python"

alias hyprc "nvim ~/.config/hypr/hyprland.lua"

alias weather "curl wttr.in"
alias sonin "shutdown +60"

alias faci "cd ~/dev/faci/"
alias notes "nvim ~/notes/"

alias update-notes "cd ~/notes/; and git add .; and git commit -m 'notes update'; and git push; cd -"
alias update-dev "cd ~/dev/; and git add .; and git commit -m 'projects update'; and git push; cd -"
alias pull-notes "cd ~/notes/; and git pull"
alias pull-dev "cd ~/dev/; and git pull"

abbr -a --position anywhere nvimc '~/.config/nvim/'
abbr -a --position anywhere hyprconf '~/.config/hypr/'
abbr -a --position anywhere kittyc '~/.config/kitty/'
abbr -a --position anywhere waybarc '~/.config/waybar/'
abbr -a --position anywhere scripts '~/dotfiles/scripts/'
abbr -a --position anywhere fishrc '~/.config/fish/config.fish'

fzf --fish | source

source ~/pyenv/bin/activate.fish

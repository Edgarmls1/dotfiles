# Disable bash completion security warnings (equivalent to ZSH_DISABLE_COMPFIX)
export BASH_COMPLETION_COMPAT_DIR="/usr/share/bash-completion/completions"

# History settings
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=" *"
shopt -s histappend
shopt -s histverify
export PROMPT_COMMAND="history -a; history -c; history -r"

# Enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Case-insensitive completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'

# Enable auto cd (bash 4.0+)
shopt -s autocd 2>/dev/null || true

# Directory stack options (similar to AUTO_PUSHD)
shopt -s cdspell
shopt -s dirspell

# Color prompt with exit status
PROMPT_COLOR="32" # green

prompt_color(){
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="32" # green
    else
        PROMPT_COLOR="31" # red
    fi
}

# Set up the prompt (equivalent to PS1 in zsh)
PROMPT_COMMAND="prompt_color; $PROMPT_COMMAND"
PS1='\n\[\e[0;${PROMPT_COLOR}m\]\w\[\e[0m\] \n\[\e[0;${PROMPT_COLOR}m\]\u@\h > \[\e[0m\]'

# Aliases
alias ls='lsd'
alias lsa='lsd -a'
alias update='~/sys_update.sh'
alias ..="cd .."
alias :q="exit"
alias cc="cd ~ && clear"
alias yays="yay -S"
alias yayr="yay -R"
alias pacmans="sudo pacman -S" 
alias pacmanr="sudo pacman -R"

# FZF integration for bash
eval "$(fzf --bash)"

# Set default editor
export EDITOR="nvim"

# Yazi function
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Bash syntax highlighting and autosuggestions (if available)
# Note: These are zsh-specific plugins. For bash alternatives:
# - Install bash-completion for better completion
# - Consider using bash-preexec + bash-git-prompt for enhanced prompts

# Conda activation
source ~/anaconda3/bin/activate
source -- ~/.local/share/blesh/ble.sh

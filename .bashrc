PROMPT_COLOR="32"

prompt_color(){
    if [[ $? -eq 0 ]]; then
        PROMPT_COLOR="32"
    else
        PROMPT_COLOR="31"
    fi
}

PROMPT_COMMAND="prompt_color; $PROMPT_COMMAND"
PS1='\n\[\e[0;${PROMPT_COLOR}m\]\w\[\e[0m\]\n\[\e[0;${PROMPT_COLOR}m\]bash > \[\e[0m\]'

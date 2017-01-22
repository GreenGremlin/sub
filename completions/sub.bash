_sub_completion() {
    _SUB="$1"
    shift
    _PATH="$1"
    shift

    COMPREPLY=()
    words=("test")
    for cword in "${COMP_WORDS[@]}" ; do
        words=("${words[@]}" "$cword")
    done
    local word="${COMP_WORDS[COMP_CWORD]}"
    local prev_word="${COMP_WORDS[COMP_CWORD - 1]}"

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "$(SUB_COMMAND_NAME="$_SUB" SUB_COMMAND_PATH="$_PATH" sub_command_main list --no-color)" -- "$word") )
    else
        local command="${COMP_WORDS[1]}"
        local completions="$(SUB_COMMAND_NAME="$_SUB" SUB_COMMAND_PATH="$_PATH" COMP_PREV="$prev_word" COMP_WORD="$word" sub_command_main completions "${COMP_WORDS[@]:1}")"
        COMPREPLY=( $(compgen -W "$completions" -- "$word") )
    fi
}

eval "function _sub_completion_${SUB_COMMAND_NAME}() { _sub_completion $SUB_COMMAND_NAME $SUB_COMMAND_PATH \"\$@\"; }"

complete -F _sub_completion_${SUB_COMMAND_NAME} $SUB_COMMAND_NAME

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

_SUB=$SUB_COMMAND_NAME
_PATH=$SUB_COMMAND_PATH

_sub_completion() {
  export SUB_COMMAND_NAME=$_SUB
  export SUB_COMMAND_PATH=$_PATH

  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD - 1]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(sub_command_main list --no-color)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(COMP_PREV="$prev_word" COMP_CWORD="$COMP_CWORD" sub_command_main completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _sub_completion $SUB_COMMAND_NAME

_sub_completion() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(sub_command_main commands --no-color)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(sub_command_main completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _sub_completion $SUB_COMMAND_NAME

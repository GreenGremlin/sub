_sub_completion() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD - 1]}"
  [ -n "$1" ] && cmd_prefix="$1" || cmd_prefix="$SUB_COMMAND_PREFIX"

  if [[ "$cmd_prefix" = "$SUB_ALIAS" ]]; then
      cmd_prefix=$SUB_COMMAND_PREFIX
  fi

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(SUB_COMMAND_PREFIX="$cmd_prefix" sub_command_main commands --no-color)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(SUB_COMMAND_PREFIX="$cmd_prefix" COMP_PREV="$prev_word" COMP_CWORD="$COMP_CWORD" sub_command_main completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _sub_completion $SUB_COMMAND_PREFIX

if [ -n "$SUB_ALIAS" ]; then
    complete -F _sub_completion $SUB_ALIAS
fi

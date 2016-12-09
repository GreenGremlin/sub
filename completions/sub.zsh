if [[ ! -o interactive ]]; then
    return
fi

compctl -K _sub_completion sub_command_main

_sub_completion() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(sub_command_main list --no-color)"
  else
    completions="$(sub_command_main completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}

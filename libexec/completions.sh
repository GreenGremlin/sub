#!/usr/bin/env bash
set -e

. "$_SUB_ROOT/lib/doc_parse.bash"

sub_command="$1"
if [ -z "$sub_command" ]; then
  echo "usage: ${SUB_COMMAND_NAME} completions COMMAND [arg1 arg2...]" >&2
  exit 1
fi

command_path="$(get_command_path "$sub_command")"

if grep -i "^# provide sub completions" "$command_path" >/dev/null; then
  shift
  # exec env CWORDS="$CWORDS" "$command_path" --complete "$@" "completions.sh"
  exec "$command_path" --complete "$@"
fi

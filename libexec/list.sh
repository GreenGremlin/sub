#!/usr/bin/env bash
# Usage: {SUB} list [--no-color]
# Summary: List all {SUB} commands
# Help: This command is mostly used for autocompletion in various shells, and for `{SUB} help`.
# Also, this command helps find commands that are named the same as potentially builtin shell commands (which, cd, etc)

set -e

contains() {
    [[ " $1 " =~ " $2 " ]] && echo "$2" || echo ""
}

. "$_SUB_ROOT/share/colors.bash"
[[ -r "$SUB_COMMAND_PATH/_alias" ]] && . "$SUB_COMMAND_PATH/_alias"

# Provide sub completions
if [ "$1" = "--complete" ]; then
    echo --sh
    echo --no-sh
    exit
fi

if [ "$1" = "--sh" ]; then
    sh=1
    shift
elif [ "$1" = "--no-sh" ]; then
    nosh=1
    shift
fi

shopt -s nullglob

if [ "$1" != "--no-color" ]; then
    function color_fn { echo `clr_yellow $1`; }
else
    function color_fn { echo $1; }
fi
{
    for path in ${SUB_COMMAND_PATH//:/$'\n'}; do
        for command in "${path}/"*; do
            command=$(basename $command)
            NAME=$(echo "$command" | cut -d'.' -f1)
            EXTENSION=$(echo "$command" | cut -d'.' -f2)
            if [[ -n "$(contains "sh js py rb" "$EXTENSION")" && "$NAME" != _* ]]; then
                echo -e `color_fn $NAME`
            fi
        done
    done
    # all subs get `help` and `list`
    echo -e `color_fn "help"`
    echo -e `color_fn "list"`
    # sub aliases
    if [[ -r "$SUB_COMMAND_PATH/_alias" ]]; then
            IFS="="
            while read -r name value; do
                    echo -e `color_fn $name`
                #     echo "Content of $name is ${value//\"/}"
            done < "$SUB_COMMAND_PATH/_alias"
    fi
} | sort | uniq

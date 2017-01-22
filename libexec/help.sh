#!/usr/bin/env bash
# Summary: Prints help text for all {SUB} commands
set -e

. "$_SUB_ROOT/lib/doc_parse.bash"
. "$_SUB_ROOT/share/colors.bash"

list_command=$(get_command_path list)
list_command_no_color="$list_command --no-color"

# Provide sub completions
if [ "$1" = "--complete" ]; then
    exec $list_command
    exit
fi

print_summaries() {
    local commands=()
    local summaries=()
    local longest_command=0
    local command

    for command in $($list_command_no_color); do
        local file="$(get_command_path "$command")"
        if [[ -e "$file" && ! -h "$file" ]]; then
            local summary="$(parse_doc Summary "$file")"
            commands["${#commands[@]}"]="$command"
            if [ -n "$summary" ]; then
                summaries["${#summaries[@]}"]=$(echo $summary)
            else
                local executes="$(parse_doc Executes "$file")"
                if [ -n "$executes" ]; then
                    summaries["${#summaries[@]}"]=$(echo `clr_cyan "Executes" clr_reset`": $executes")
                else
                    summaries["${#summaries[@]}"]=`clr_magenta "* No help summary found for "``clr_cyan "$command"`
                fi
            fi
            if [ "${#command}" -gt "$longest_command" ]; then
                longest_command="${#command}"
            fi
        fi
    done

    local index
    local columns="$(tput cols)"
    local summary_length=$(( $columns - $longest_command - 5 ))

    for (( index=0; index < ${#commands[@]}; index++ )); do
        printf `clr_yellow "%-${longest_command}s"`"    %s\n" "${commands[$index]}" \
            "${summaries[$index]}"
    done
}

print_help() {
    local file="$1"
    local cmd=$2
    local usage="$(parse_doc Usage "$file")"
    local summary="$(parse_doc Summary "$file")"
    local executes="$(parse_doc Executes "$file")"
    local options="$(parse_multiline_doc Options "$file")"
    local help_text="$(parse_multiline_doc Help "$file")"

    if [[ -n "$usage" || -n "$help" || -n "$summary" ]]; then
        if [ -n "$usage" ]; then
            echo && echo `clr_cyan "Usage" clr_reset`": $usage"
        fi

        if [ -n "$summary" ]; then
            echo && echo "$summary"
        fi

        if [ -n "$executes" ]; then
            echo && echo `clr_cyan "Executes" clr_reset`": $executes"
        fi

        if [ -n "$options" ]; then
            echo && echo `clr_cyan "Options" clr_reset`":"
            echo && echo "$(indent "$options" 2)"
        fi

        if [ -n "$help_text" ]; then
            echo && echo "$help_text"
        fi
    else
        echo && echo "Sorry, the \`$cmd\` command isn't documented yet."
    fi
}

sub_command="$1"
case "$sub_command" in
"" | "-h" | "--help" | "help")
    echo "Usage: $SUB_COMMAND_NAME <sub-command> [...]"
    echo
    echo "Sub-command help: "`clr_green "$SUB_COMMAND_NAME <sub-command> --help"`
    echo
    echo "Available sub-commands:"
    echo
    print_summaries
    ;;
*)
    file="$(get_command_path "$sub_command")"

    if [ -n "$file" ]; then
        print_help "$file" "$sub_command"
    else
        echo "$SUB_COMMAND_NAME: no such command \`$sub_command\`" >&2
        exit 1
    fi
esac
#!/usr/bin/env bash

indent() {
    indentation="$(repeat_char " " $2)"
    echo "$1" | sed "s/^[[:space:]]*/$indentation/"
}

parse_doc() {
    section="$1"
    script="$2"
    doc=$(sed -n "s/^# $section: \(.*\)/\1/p" "$script")
    echo ${doc/\{SUB\}/$SUB_COMMAND_NAME}
}

parse_multiline_doc() {
    # grab block start to start of next | remove virst line | uncomment and remove key | trim leading newlines
    awk "/^# $1:/,!/^# {2,}|^#$|^# $1:/" "$2" | sed '$d' | sed "s/^# $1:[[:space:]]*//;s/^# //;s/^#//" | sed '/./,$!d'
}

repeat_char() {
    printf "%0.s$1" $(seq 1 $2)
}

get_command_path() {
    for ext in sh js py rb; do
        command_path=$(command -v "$SUB_COMMAND_PATH/$1.$ext")
        if [[ -n "$command_path" ]]; then
            break
        fi
    done
    if [[ -z "$command_path" ]]; then
        for ext in sh js py rb; do
            command_path=$(command -v "$SUB_LIB_PATH/$1.$ext")
            if [[ -n "$command_path" ]]; then
                break
            fi
        done
    fi
    echo "$command_path"
}

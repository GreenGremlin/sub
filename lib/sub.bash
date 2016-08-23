#!/usr/bin/env bash
# SOURCE
# to instantiate with this, add:
# tmp=`pwd`; # cd SUB_PATH && . sub-init && cd $tmp
# to your bashrc

if [ -z ${SUB_COMMAND_NAME+x} ]; then
  export SUB_COMMAND_NAME="sub"
fi

if [ -z ${SUB_COMMAND_PREFIX+x} ]; then
  export SUB_COMMAND_PREFIX="sub"
fi

if [ -z ${_SUB_ROOT+x} ]; then
  export _SUB_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
fi

export SUB_PATH="$_SUB_ROOT/libexec"

_sub_resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

_sub_abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(_sub_resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

_sub_source() {
  local out=`grep $'#[ \t]*SOURCE' $1`
  if [ "$out" == "" ]; then
    echo "0"
    return
  fi
  echo "1"
}

case "$0" in
bash | zsh)
  . "$_SUB_ROOT/completions/sub.$0"
  ;;
-bash )
  . "$_SUB_ROOT/completions/sub.bash"
  ;;
esac

function sub_command_main() {
  local original_path=$PATH
  local source_command=0
  export PATH="$SUB_PATH:$PATH"

  libexec_path=$SUB_PATH

  last_arg="${@: -1}"
  case "$last_arg" in
  "" | "-h" | "--help" | "help" )
      if [ -e "${SUB_PATH}/${SUB_COMMAND_PREFIX}-help" ]; then
          "${SUB_COMMAND_PREFIX}-help" "$@"
      else
          sub-help "$@"
      fi
    ;;
  "commands" )
      if [ -e "${SUB_PATH}/${SUB_COMMAND_PREFIX}-commands" ]; then
          "${SUB_COMMAND_PREFIX}-commands" "$@"
      else
          sub-commands "$@"
      fi
  ;;
  * )
    command_path="$(command -v "${SUB_COMMAND_PREFIX}-${1}" || true)"
    if [ ! -x "$command_path" ]; then
      echo "${SUB_COMMAND_NAME}: no such command \`$1\`"
    else
        source_command=$(_sub_source $command_path)
        shift
        if [[ "${1}" == "--complete" ]]; then
            $command_path "$@"
        elif [[ "$source_command" -eq 0 ]]; then
            $command_path "$@"
        else
            . $command_path "$@"
        fi
    fi
    ;;
  esac
  export PATH=$original_path
}

sub_alias() {
    command_name=$1
    shift
    orig_name=$SUB_COMMAND_NAME;
    export SUB_COMMAND_NAME="${command_name}";
    sub_command_main "$@";
    export SUB_COMMAND_NAME="${orig_name}";
}

prefixed_sub_alias() {
    command_name=$1
    orig_prefix=$SUB_COMMAND_PREFIX;
    export SUB_COMMAND_PREFIX="${command_name}";
    sub_alias "$@";
    export SUB_COMMAND_PREFIX="${orig_prefix}";
}

# SUB_ALIAS (export SUB_ALIAS='alias1')
if [ -n ${SUB_ALIAS+x} ]; then
    # eval "alias ${sub_alis}='sub_command_main'"
    eval "${SUB_ALIAS}() { sub_alias ${SUB_ALIAS} \"\$@\"; }"
fi

# SUB_PREFIX (export SUB_PREFIX='pre1:pre2' colon separated list)
{ for command_name in ${SUB_PREFIX//:/$'\n'}; do
    eval "${command_name}() { prefixed_sub_alias ${command_name} \"\$@\"; }"
  done
}

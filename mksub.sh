#!/usr/bin/env bash


SUB_NAME=$1
# SUB_COMMAND_PATH=${2%/}
SUB_COMMAND_PATH=$(cd $2; pwd)

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat << EOM
#!/usr/bin/env bash
set -e

$BASE_DIR/sub.sh $SUB_NAME $SUB_COMMAND_PATH "\$@"

EOM

#!/usr/bin/env bash

SUB_COMMAND_PATH=${1%/}
shift
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat << EOM
#!/usr/bin/env bash
set -e

$BASE_DIR/sub.sh \$(basename "\$0") $SUB_COMMAND_PATH "\$@"

EOM

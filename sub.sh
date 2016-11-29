#!/usr/bin/env bash
set -e

# parent directory of this script
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

. "$BASE_DIR/lib/sub.bash"

sub_command_main "$@"

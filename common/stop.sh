#!/bin/bash
set -eu
DOCKER_APP_DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
source "${DOCKER_APP_DIR}/../common/baseconfig.sh"

docker stop ${DOCKER_APP_NAME}

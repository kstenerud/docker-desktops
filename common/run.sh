#!/bin/bash
set -eu
DOCKER_APP_DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
source "${DOCKER_APP_DIR}/../common/baseconfig.sh"

docker run -d \
           --init \
           -p ${DOCKER_APP_RDP_PORT}:3389 \
           -p ${DOCKER_APP_SSH_PORT}:22 \
           ${DOCKER_APP_VOLUME_PARAM} \
           --name ${DOCKER_APP_NAME} \
           -h ${DOCKER_APP_NAME} \
           ${DOCKER_APP_START_OPTIONS} \
           ${DOCKER_IMAGE_NAME}

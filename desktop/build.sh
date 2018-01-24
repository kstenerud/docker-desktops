#!/bin/bash
set -eu
DOCKER_APP_DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
source "${DOCKER_APP_DIR}/../common/baseconfig.sh"

pushd "${DOCKER_APP_DIR}"
	docker build -t ${DOCKER_IMAGE_NAME} ${DOCKER_BUILD_OPTIONS} .
popd

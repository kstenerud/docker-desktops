#!/bin/bash

set -eu

if [ $# -ne 2 ]; then
	echo "Usage: $0 <name> <password>"
	exit 1
fi

ARG_USER=$1
ARG_PASSWORD=$2

addgroup tsusers &>/dev/null
useradd --create-home --shell /bin/bash --user-group --groups adm,sudo,tsusers $USER && \
echo "$USER:$PASSWORD" | chpasswd

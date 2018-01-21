#!/bin/bash

set -eu

if [ $# -ne 4 ]; then
	echo "Usage: $0 <language> <region> <keyboard layout> <keyboard model>"
	echo "Example: $0 en US us pc105"
	echo "... which chooses locale en_US.UTF-8, with \"us\" keyboard model \"pc105\""
	exit 1
fi

ARG_LANGUAGE=$1
ARG_REGION=$2
ARG_KB_LAYOUT=$3
ARG_KB_MODEL=$4

LANG_BASE=${ARG_LANGUAGE}_${ARG_REGION}
LANG_FULL=${LANG_BASE}.UTF-8

locale-gen ${LANG_BASE} ${LANG_FULL}
update-locale LANG=${LANG_FULL}
# Only LANG seems to be necessary
#update-locale LANG=${LANG_FULL} LANGUAGE=${LANG_BASE}:${ARG_LANGUAGE} LC_ALL=${LANG_FULL}
echo "keyboard-configuration keyboard-configuration/layoutcode string ${ARG_KB_LAYOUT}" | debconf-set-selections
echo "keyboard-configuration keyboard-configuration/modelcode string ${ARG_KB_MODEL}" | debconf-set-selections

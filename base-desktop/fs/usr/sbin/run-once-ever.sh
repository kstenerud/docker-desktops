#!/bin/bash

# Looks for scripts in /var/local/run-once-ever, executes them with bash,
# and then deletes them so that they won't be run again.
LOGFILE=/var/log/run-once-ever.log


set -eu
if [ -d /var/local/run-once-ever ]; then
    cd /var/local/run-once-ever
    if ls *.sh 1> /dev/null 2>&1; then
        for script in *.sh; do
        	set +e
            /bin/bash "$script" &>> "$LOGFILE"
            rm "$script"
            set -e
        done
    fi
fi

#!/bin/bash

# Simple Supervisor
# =================
#
# Monitors services and starts them whenever they're down.
#
# ssupervisor monitors a list of services, and if a particular service
# is down, restarts it using `service <myservice> start`
#
# Usage
# -----
#
# Usage: ssupervisor.sh
#
#
# Services File
# -------------
#
# ssupervisor reads /etc/ssupervisor/services for a list of services to monitor.
# The line format is <service> [delay]
# Where:
#   service = the name of the service
#   delay   = (floating point) delay in seconds before starting the service
#
# Lines beginning with # are ignored.
#
# Note: The file MUST end in an empty line or else the last line will be ignored!
#
# Example file:
# ssh 0
# # 0 by default
# nmbd
# smbd 0.2
# mycomplicatedservice 3
#
#
# License & Copyright
# -------------------
#
# Copyright (c) Karl Stenerud
#
# Released under standard MIT License https://opensource.org/licenses/MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in the documentation of any redistributions of the template files themselves (but not in projects built using the templates).
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -eu

# Configuration

POLL_INTERVAL_SECONDS=5
SERVICES_FILE="/etc/ssupervisor/services"
LOG_FILE="/var/log/ssupervisor.log"


# Globals

declare -a SERVICE_ORDER
declare -a SERVICE_DELAY
SERVICE_COUNT=0


# Functions

load_services() {
	index=0
	while IFS= read -r var
	do
		if [[ ! $var = \#* ]]; then
			service=$(echo "$var" | awk '{print $1}')
			delay=$(echo "$var" | awk '{print $2}')
			if [ ! -z "$service" ] && [ "$service" != "#*" ]; then
				if [ -z "$delay" ]; then
					delay=0
				fi
				set +u
				SERVICE_ORDER[$index]=$service
				SERVICE_DELAY[$service]=$delay
				set -u
				index=$(( index + 1 ))
			fi
		fi
	done < "$SERVICES_FILE"
	SERVICE_COUNT=$index
}

is_service_running() {
	service $1 status >> /dev/null
}

start_service() {
	service=$1
	service $service stop
	service $service start
}

supervise_services() {
	index=0
	while [ $index -lt $SERVICE_COUNT ]
	do
		service=${SERVICE_ORDER[$index]}
		set +e
		if ! is_service_running $service; then
			set +u
			sleep ${SERVICE_DELAY[$service]}
			set -u
			start_service $service
		fi
		set -e
		index=$(( index + 1 ))
	done
}

run_once_per_boot() {
	if [ -f /etc/ssupervisor/run-once-per-boot.sh ]; then
		/etc/ssupervisor/run-once-per-boot.sh
	fi
}

main() {
	load_services
	supervise_services
	sleep 1
	run_once_per_boot

	while [ 1 ]; do
		sleep $POLL_INTERVAL_SECONDS
		supervise_services
	done
}

main &>> "$LOG_FILE"

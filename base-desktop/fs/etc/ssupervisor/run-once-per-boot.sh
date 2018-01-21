#!/bin/bash
set -x

rm /var/run/xrdp-sesman.pid
/usr/sbin/xrdp-sesman
rm /var/run/xrdp.pid
/usr/sbin/xrdp

# Best to run this last to make sure everything that should be running is running.
sleep 1
/usr/sbin/run-once-ever.sh

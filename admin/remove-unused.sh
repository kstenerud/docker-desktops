#!/bin/sh

docker rmi $(docker images -q -f dangling=true)

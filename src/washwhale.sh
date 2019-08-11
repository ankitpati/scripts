#!/usr/bin/env bash

proc="$(docker ps -a -q)"
test -n "$proc" && docker stop $proc && docker rm $(docker ps -a -q)

vols="$(docker volume ls -q)"
test -n "$vols" && docker volume rm $vols

dang="$(docker images -a --filter=dangling=true -q)"
test -n "$dang" && docker rmi "$dang"

imgs="$(docker images -a -q)"
#test -n "$imgs" && docker rmi --force $imgs

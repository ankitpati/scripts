#!/usr/bin/env bash

proc="$(podman ps -a -q)"
test -n "$proc" && podman stop $proc && podman rm $(podman ps -a -q)

vols="$(podman volume ls -q)"
test -n "$vols" && podman volume rm $vols

podman image prune

#podman image prune --all

#!/usr/bin/env bash

me="$(basename "$0")"
usage="Usage: $me <username[:groupname]> <path>... -- [bash arguments]"

test "$#" -lt 3 && echo "$usage" && exit 1

for arg in "$@"; do test '--' = "$arg" && break; done
test '--' != "$arg" && echo "$usage" && exit 2

user_group="$1"
shift # remove username:groupname

while test -n "$1" -a '--' != "$1"
do
    chown "$user_group" -hR "$1" || exit 3 # die immediately upon failure
    shift # remove paths we have dealt with
done
shift # remove '--'

username="${user_group/%:*/}" # no sed because it may not be installed
exec su - "$username" -- "$@"

#!/usr/bin/env bash

myname="$(basename "$0")"

test "$#" -eq 0 && printf "Usage:\n\t$myname <username>...\n" && exit 1

error_users=''

for username in "$@"
do
    ssh my-server sss_ssh_authorizedkeys "$username" 2>'/dev/null' || \
        error_users="$username, $error_users"
done

error_users="$(echo "$error_users" | sed 's/, $//')"

test "$error_users" && \
    echo "No public key found for $error_users." >&2 && exit 2

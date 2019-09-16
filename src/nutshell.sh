#!/usr/bin/env bash

me="$(basename "$0")"
usage="Usage: $me <username[:groupname]> <path>... -- [bash arguments]"

test "$#" -lt 3 && echo "$usage" && exit 1

for arg in "$@"; do test '--' = "$arg" && break; done
test '--' != "$arg" && echo "$usage" && exit 2

user_group="$1"
shift # remove username:groupname

while test '--' != "$1"
do
    chown "$user_group" -hR "$1" || exit 3 # die immediately upon failure
    shift # remove paths we have dealt with
done
shift # remove '--'

username="${user_group/%:*/}" # no sed because it may not be installed
userhome="$(getent passwd "$username" | cut -d':' -f6)"

mapfile -t env2exp < <(compgen -e | grep -Ev "^(HISTCONTROL|HISTSIZE|HOME|\
HOSTNAME|LANG|LD_LIBRARY_PATH|LESSOPEN|LOGNAME|LS_COLORS|MAIL|OLDPWD|PATH|PWD|\
SHELL|SHLVL|TERM|USER)\$")

for env_key in "${env2exp[@]}"
do
    env4sudo=("${env4sudo[@]}" "$env_key=${!env_key}")
    env4bashrc="$env4bashrc$(printf 'export %s=%q\n' "$env_key" "${!env_key}")"
done

# `sudo`, if available, is always the better option: it does not call a shell
test -n "$(command -v sudo)" && \
    exec sudo -u "$username" "${env4sudo[@]}" -- "$@"

# `su` is a fallback; calls the login shell of the specified user
echo "$env4bashrc" >> "$userhome/.bashrc"
exec su - "$username" -- "$@"

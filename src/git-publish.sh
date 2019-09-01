#!/usr/bin/env bash

myname="$(basename "$0")"

args=("$@")
for i in "${!args[@]}"
do
    if [[ "${args[$i]}" == -* ]]
    then
        pushparams=("${pushparams[@]}" "${args[$i]}")
        unset 'args[$i]'
    fi
done

test "${#args[@]}" -eq 0 \
    && echo "Usage: $myname [-<git-push-params>...] <branch>..." \
    && exit 1

test -z "$(git rev-parse --show-toplevel)" && \
    echo "$myname: present directory must be in a Git repository" && exit 2

remotes=('sgh' 'sgl' 'sbb')
for branch in "${args[@]}"
do
    for remote in "${remotes[@]}"
    do
        git push "${pushparams[@]}" "$remote" "$branch" &
    done
done

wait # guard against premature prompt

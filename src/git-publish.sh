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

for branch in "${args[@]}"
do
    git push "${pushparams[@]}" sgh "$branch" &
    git push "${pushparams[@]}" sgl "$branch" &
    git push "${pushparams[@]}" sbb "$branch" &
done

wait # guard against premature prompt

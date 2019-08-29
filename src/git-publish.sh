#!/usr/bin/env bash

myname="$(basename "$0")"

test '-f' = "$1" && shift && force=('-f')

test "$#" -eq 0 && echo "Usage: $myname [-f] <branch>..." && exit 1
test -z "$(git rev-parse --show-toplevel)" && \
    echo "$myname: present directory must be in a Git repository" && exit 2

for branch in "$@"
do
    git push "${force[@]}" sgh "$branch" &
    git push "${force[@]}" sgl "$branch" &
    git push "${force[@]}" sbb "$branch" &
done

wait # guard against premature prompt

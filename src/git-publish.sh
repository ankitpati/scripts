#!/usr/bin/env bash

myname="$(basename "$0")"

test "$#" -eq 0 && echo "Usage: $myname <branch>..." && exit 1
test -z "$(git rev-parse --show-toplevel)" && \
    echo "$myname: present directory must be in a Git repository" && exit 2

for branch in "$@"
do
    git push sgh "$branch"
    git push sgl "$branch"
    git push sbb "$branch"
done

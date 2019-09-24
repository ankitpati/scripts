#!/usr/bin/env bash

set -e

git rev-parse --show-toplevel

mapfile -t remotes < <(git remote)

find . -type f -name '.gitignore' -delete
git clean -fd
git checkout -f

for remote in "${remotes[@]}"
do
    git remote prune "$remote"
done

git reflog expire --all --expire=now
git -c gc.reflogExpire=0 \
    -c gc.reflogExpireUnreachable=0 \
    -c gc.rerereresolved=0 \
    -c gc.rerereunresolved=0 \
    -c gc.pruneExpire=now \
    gc --prune=now --aggressive

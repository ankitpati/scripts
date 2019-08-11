#!/usr/bin/env bash

git rev-parse --show-toplevel && \
find . -type f -name '.gitignore' -delete && \
git clean -fd && \
git checkout -f && \
git remote prune $(git remote) && \
git reflog expire --all --expire=now && \
git -c gc.reflogExpire=0 \
    -c gc.reflogExpireUnreachable=0 \
    -c gc.rerereresolved=0 \
    -c gc.rerereunresolved=0 \
    -c gc.pruneExpire=now \
    gc --prune=now --aggressive

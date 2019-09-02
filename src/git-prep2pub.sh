#!/usr/bin/env bash

myname="$(basename "$0")"

test "$#" -ne 2 -a "$#" -ne 3 \
    && echo "Usage: $myname <username> <repository> [aws-region]" \
    && exit 1

test -z "$(git rev-parse --show-toplevel)" && \
    echo "$myname: present directory must be in a Git repository" && exit 2

username="$1"
repository="$2"
aws_region="${3:-ap-south-1}"

declare -A map
map=(
    [gh]="https://$username@github.com/$username"
    [gl]="https://$username@gitlab.com/$username"
    [bb]="https://$username@bitbucket.org/$username"
    [az]="https://git-codecommit.$aws_region.amazonaws.com/v1/repos"
    [nb]="https://$username@notabug.org/$username"
    [sgh]="ssh://github.com/$username"
    [sgl]="ssh://gitlab.com/$username"
    [sbb]="ssh://bitbucket.org/$username"
    [saz]="ssh://git-codecommit.$aws_region.amazonaws.com/v1/repos"
    [snb]="ssh://notabug.org/$username"
);

for remote in "${!map[@]}"
do
    git remote remove "$remote"
    git remote add "$remote" "${map[$remote]}/$repository.git"
done

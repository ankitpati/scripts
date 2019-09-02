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
    [az]="git-codecommit.$aws_region.amazonaws.com/v1/repos"
    [bb]="bitbucket.org/$username"
    [gh]="github.com/$username"
    [gl]="gitlab.com/$username"
    [nb]="notabug.org/$username"
);

for remote in "${!map[@]}"
do
    hostpath="${map[$remote]}/$repository.git"

    git remote remove "$remote"
    git remote add "$remote" "https://$username@$hostpath"

    git remote remove "s$remote"
    git remote add "s$remote" "ssh://$hostpath"
done

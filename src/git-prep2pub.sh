#!/usr/bin/env bash

myname="$(basename "$0")"

test "$#" -ne 2 && echo "Usage: $myname <username> <repository>" && exit 1
test -z "$(git rev-parse --show-toplevel)" && \
    echo "$myname: present directory must be in a Git repository" && exit 2

username="$1"
repository="$2"

for remote in origin gh gl bb nb sgh sgl sbb snb
do
    git remote remove "$remote"
done

git remote add gh "https://$username@github.com/$username/$repository.git"
git remote add gl "https://$username@gitlab.com/$username/$repository.git"
git remote add bb "https://$username@bitbucket.org/$username/$repository.git"
git remote add nb "https://$username@notabug.org/$username/$repository.git"
git remote add sgh "ssh://git@github.com/$username/$repository.git"
git remote add sgl "ssh://git@gitlab.com/$username/$repository.git"
git remote add sbb "ssh://git@bitbucket.org/$username/$repository.git"
git remote add snb "ssh://git@notabug.org/$username/$repository.git"

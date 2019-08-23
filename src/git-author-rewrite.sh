#!/usr/bin/env bash

me="$(basename "$0")"

test "$#" -ne 3 && echo "Usage: $me <old-email> <new-name> <new-email>" && \
    exit 1

old_email="$1"
new_name="$2"
new_email="$3"

git filter-branch --env-filter "$(cat <<EOF

    if [ "\$GIT_COMMITTER_EMAIL" = "$old_email" ]
    then
        export GIT_COMMITTER_NAME="$new_name"
        export GIT_COMMITTER_EMAIL="$new_email"
    fi
    if [ "\$GIT_AUTHOR_EMAIL" = "$old_email" ]
    then
        export GIT_AUTHOR_NAME="$new_name"
        export GIT_AUTHOR_EMAIL="$new_email"
    fi
EOF
)" --tag-name-filter cat -- --branches --tags

#!/usr/bin/env bash

myname="$(basename "$0")"
mydir="$(dirname "$0")/"

test "$#" -ne 1 -o ! -d "$1" && echo "Usage: $myname <directory>" && exit 1

TARGET_DIRECTORY="$1"

find "$TARGET_DIRECTORY" -type f -exec chmod 600 {} +
find "$TARGET_DIRECTORY" -type d -exec chmod 700 {} +
find "$TARGET_DIRECTORY" -not \( -type d -o -type f \) -print -delete

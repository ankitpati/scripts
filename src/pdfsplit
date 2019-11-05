#!/usr/bin/env bash

myname="$(basename "$0")"
usage="Usage: $myname <input.pdf>"

test "$#" -ne 1 && echo "$usage" && exit 1

numpages="$(gs -q -d'NODISPLAY' \
               -c "($1) (r) file runpdfbegin pdfpagecount = quit" \
            2>'/dev/null')"

test "$numpages" || numpages=0

echo "Processing $numpages pages..."

for counter in $(seq "$numpages")
do
    newname="$(echo "$1" | sed 's/\.pdf//g')"
    newnamenum="$newname-$counter.pdf"
    yes | gs -d'BATCH' -s"OutputFile=$newnamenum" -d"FirstPage=$counter" \
             -d"LastPage=$counter" -s'DEVICE=pdfwrite' "$1" >& '/dev/null'
done

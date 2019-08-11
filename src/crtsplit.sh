#!/usr/bin/env bash

myname="$(basename "$0")"

test "$#" -ne 1 -o ! -f "$1" && echo "Usage: $myname <filename>" && exit 1

crtfile="$1"

openssl crl2pkcs7 -nocrl -certfile "$crtfile" | \
    openssl pkcs7 -print_certs -text -noout

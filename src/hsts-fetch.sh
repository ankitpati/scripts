#!/usr/bin/env bash
# hsts-fetch
# Fetch Google Chrome HSTS List

# https://code.google.com/p/chromium/issues/detail?id=226801
url='https://chromium.googlesource.com/chromium/src/net/+/master/http/transport_security_state_static.json?format=TEXT';
curl -#s "$url" | base64 --decode | sed '/^ *\/\// d' | sed '/^\s*$/d' | \
                                            jt entries [ name % ] | sort | uniq

#!/bin/bash

ssh remote mkdir '/home/administrator/.cache/var.cache.apt.archives/'
scp -r '/var/ftp/public_ftp/Ubuntu 16.04/32 bit/var.cache.apt.archives' remote:/home/administrator/.cache/

ssh -t remote '~/bin/apt-clean.sh'

rm -rf '/var/ftp/public_ftp/Ubuntu 16.04/32 bit/var.cache.apt.archives'

scp -r remote:/home/administrator/.cache/var.cache.apt.archives '/var/ftp/public_ftp/Ubuntu 16.04/32 bit/'
ssh remote rm -rf '/home/administrator/.cache/var.cache.apt.archives/'

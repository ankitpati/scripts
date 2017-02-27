#!/bin/bash

sudo find ~/.cache/var.cache.apt.archives/ -type f -exec mv -t /var/cache/apt/archives/ {} +
sudo find /var/cache/apt/archives/ -type f -name "*.deb" -exec chown root:root {} +

sudo apt autoclean

sudo find /var/cache/apt/archives/ -type f -name "*.deb" -exec mv -t ~/.cache/var.cache.apt.archives/ {} +
sudo find ~/.cache/var.cache.apt.archives/ -type f -exec chown administrator:administrator {} +

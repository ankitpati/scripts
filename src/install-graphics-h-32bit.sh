#!/bin/bash

cd ~ && \
sudo apt -y install git geany geany-plugins libsdl2-2.0-0 libsdl2-dev && \
wget 'https://ankitpati.in/downloads/SDL_bgi-2.0.8.tar.gz' && \
tar -xzf SDL_bgi-2.0.8.tar.gz && \
cd SDL_bgi-2.0.8/src/ && \
make && sudo make install && \
sudo ln -sT /usr/lib/libSDL_bgi.so.2.0.8 /usr/lib/libSDL_bgi.so && \
cd ~ && \
git clone https://github.com/ankitpati/geany-config.git && \
rm -rf .config/geany && \
mv geany-config .config/geany && \
rm SDL_bgi-2.0.8.tar.gz && \
rm -rf SDL_bgi-2.0.8/ && \
echo 'Done!'

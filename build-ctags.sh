#!/bin/bash
#

sudo apt update
sudo apt install -y autoconf automake pkg-config libseccomp-dev git make gcc

git clone https://github.com/universal-ctags/ctags.git ~/ctags
cd ~/ctags

./autogen.sh
./configure --prefix=/usr/local
make -j$(nproc)
sudo make install

ctags --version


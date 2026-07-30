#!/bin/bash
set -e

sudo dpkg --add-architecture i386
sudo apt update

BASE=https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses

# amd64
wget -c $BASE/libtinfo5_6.3-2ubuntu0.2_amd64.deb
wget -c $BASE/libncurses5_6.3-2ubuntu0.2_amd64.deb

# i386
wget -c $BASE/libtinfo5_6.3-2ubuntu0.2_i386.deb
wget -c $BASE/libncurses5_6.3-2ubuntu0.2_i386.deb

sudo apt install ./libtinfo5_6.3-2ubuntu0.2_amd64.deb \
                 ./libncurses5_6.3-2ubuntu0.2_amd64.deb \
                 ./libtinfo5_6.3-2ubuntu0.2_i386.deb \
                 ./libncurses5_6.3-2ubuntu0.2_i386.deb

sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl \
  libncursesw5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev git

mkdir -p ~/python2-debs && cd ~/python2-debs
B_URL="http://ubuntu.com"
VERSION_SUFX="2.7.18-13ubuntu1.5_amd64.deb"
wget "${B_URL}/libpython2.7-minimal_${VERSION_SUFX}"
wget "${B_URL}/python2.7-minimal_${VERSION_SUFX}"
wget "${B_URL}/libpython2.7-stdlib_${VERSION_SUFX}"
wget "${B_URL}/python2.7_${VERSION_SUFX}"
sudo dpkg -i libpython2.7-minimal_*.deb python2.7-minimal_*.deb libpython2.7-stdlib_*.deb python2.7_*.deb
cd ~ && rm -rf ~/python2-debs
sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2
sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2.7

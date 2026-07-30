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

sudo apt update
sudo apt install -y build-essential checkinstall libreadline-dev \
  libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev \
  libc6-dev libbz2-dev libffi-dev zlib1g-dev
cd /usr/src
sudo wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
sudo tar xzf Python-2.7.18.tgz
cd Python-2.7.18
sudo ./configure --enable-optimizations
sudo make altinstall


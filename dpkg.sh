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

# Download and install Python 2.7 DEB packages from Ubuntu 22.04 archives
wget http://security.ubuntu.com/ubuntu/pool/universe/p/python2.7/python2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb
sudo apt install -y ./python2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb
sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2
rm python2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb

sudo apt install -y git-core gnupg flex bison build-essential zip curl \
  zlib1g-dev libx11-dev libxml2-utils xsltproc unzip openjdk-8-jdk bc rsync \
  libstdc++6:i386 zlib1g:i386 python2-minimal nano

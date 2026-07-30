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

sudo apt install -y git-core gnupg flex bison build-essential zip curl \
  zlib1g-dev libx11-dev libxml2-utils xsltproc unzip openjdk-8-jdk bc rsync \
  libstdc++6:i386 zlib1g:i386 python2-minimal nano

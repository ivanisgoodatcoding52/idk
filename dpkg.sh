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

mkdir -p ~/python2-master && cd ~/python2-master

# 2. Map standard directory endpoints to the Main Archive Pool
M_POOL="http://ubuntu.com"
V_TAG="2.7.18-13ubuntu1_amd64.deb"

# 3. Pull down the exact full system package chain sequentially
wget "${M_POOL}/libpython2.7-minimal_${V_TAG}"
wget "${M_POOL}/python2.7-minimal_${V_TAG}"
wget "${M_POOL}/libpython2.7-stdlib_${V_TAG}"
wget "${M_POOL}/python2.7_${V_TAG}"

# 4. Simultaneously force configure the dependency chain via dpkg
sudo dpkg -i libpython2.7-minimal_*.deb python2.7-minimal_*.deb libpython2.7-stdlib_*.deb python2.7_*.deb

# 5. Clean up downloaded package remnants
cd ~ && rm -rf ~/python2-master

# 6. Rebind execution paths for legacy Qualcomm build triggers
sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2
sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2.7

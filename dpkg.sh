#!/bin/bash
# Exit immediately if any command returns a failure status code
set -e

echo "================================================================"
echo " STAGE 1: FORCE CONFIGURING LEGACY 64-BIT & 32-BIT NCURSES HALs"
echo "================================================================"

# Enable cross-architecture compilation hooks for your Snapdragon S4 processor
sudo dpkg --add-architecture i386
sudo apt update

# Source base repository endpoint definition
BASE=https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses

# Fetch the exact matching production package versions
wget -c $BASE/libtinfo5_6.3-2ubuntu0.2_amd64.deb
wget -c $BASE/libncurses5_6.3-2ubuntu0.2_amd64.deb
wget -c $BASE/libtinfo5_6.3-2ubuntu0.2_i386.deb
wget -c $BASE/libncurses5_6.3-2ubuntu0.2_i386.deb

# Concurrently force configure the packages bypassing database locks
sudo apt install -y ./libtinfo5_6.3-2ubuntu0.2_amd64.deb \
                    ./libncurses5_6.3-2ubuntu0.2_amd64.deb \
                    ./libtinfo5_6.3-2ubuntu0.2_i386.deb \
                    ./libncurses5_6.3-2ubuntu0.2_i386.deb

# Erase structural deb file leftovers
rm -f *.deb

echo "================================================================"
echo " STAGE 2: INSTALLING ENTIRE BUILDING ENGINES AND HEADER LIBS"
echo "================================================================"
sudo apt update
sudo apt install -y git-core gnupg flex bison build-essential zip curl \
  zlib1g-dev libx11-dev libxml2-utils xsltproc unzip openjdk-8-jdk bc rsync \
  libstdc++6:i386 zlib1g:i386 nano checkinstall libreadline-dev \
  libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libffi-dev liblzma-dev

echo "================================================================"
echo " STAGE 3: DOWNLOADING AND COMPIILING PYTHON 2.7.18 FROM SOURCE"
echo "================================================================"
cd /usr/src
sudo wget -c https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
sudo tar xzf Python-2.7.18.tgz
cd Python-2.7.18

# Injecting strict modern compiler flag adjustments to override modern GCC blocks
sudo ./configure --enable-optimizations CFLAGS="-std=c11"

# Process compilation multi-threaded across available CPU hardware channels
sudo make -j$(nproc)
sudo make altinstall

echo "================================================================"
echo " STAGE 4: MAPPING PERSISTENT ALIAS SYM-LINKS"
echo "================================================================"
# Explicitly connect the output binary maps to your main system execution paths
sudo ln -sf /usr/local/bin/python2.7 /usr/local/bin/python2
sudo ln -sf /usr/local/bin/python2.7 /usr/local/bin/python2.7

# Ensure the global orchestration tools launch via Python3 by default
sudo ln -sf /usr/bin/python3 /usr/local/bin/python

echo "================================================================"
echo " SYSTEM LEVEL PREPARATION SUCCESSFUL!"
echo " Verification: $(python2 --version)"
echo "================================================================"

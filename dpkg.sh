# 1. Enable your system's 32-bit architecture support
sudo dpkg --add-architecture i386
sudo apt update

# 2. Download the 64-bit dependency packages
curl -O http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2_amd64.deb
curl -O http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.4-2_amd64.deb

# 3. Download the 32-bit dependency packages
curl -O http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2_i386.deb
curl -O http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.4-2_i386.deb

# 4. Install them sequentially
sudo dpkg -i libtinfo5_6.4-2_amd64.deb
sudo dpkg -i libncurses5_6.4-2_amd64.deb
sudo dpkg -i libtinfo5_6.4-2_i386.deb
sudo dpkg -i libncurses5_6.4-2_i386.deb

# 5. Clean up the downloaded packages
rm -f libtinfo5_*.deb libncurses5_*.deb

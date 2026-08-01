sudo apt update
sudo apt upgrade -y

sudo apt install -y \
bc bison build-essential ccache curl flex \
g++-multilib gcc-multilib git git-lfs gnupg \
gperf imagemagick lib32ncurses5-dev \
lib32readline-dev lib32z1-dev liblz4-tool \
libncurses-dev libssl-dev libxml2 \
libxml2-utils lzop openjdk-8-jdk \
pngcrush rsync schedtool squashfs-tools \
xsltproc zip zlib1g-dev \
python3 python-is-python3

java -version
python --version

mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo \
-o ~/bin/repo
chmod +x ~/bin/repo

echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

repo --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"


mkdir -p ~/android/lineage
cd ~/android/lineage

repo init \
-u https://github.com/LineageOS/android.git \
-b lineage-17.1 #Change the thing here"

repo sync -c --no-clone-bundle --no-tags -j$(nproc)

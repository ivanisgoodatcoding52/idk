#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "================================================================="
echo "   COMMENCING REPOSITORY WORKSPACE GENERATION FOR D2ATT"
echo "================================================================="

# 1. SETUP SYSTEM PATH AND FETCH GOOGLE REPO UTILITY TOOL
echo "[*] Initializing local bin paths and downloading Google Repo tool..."
mkdir -p ~/bin
curl https://googleapis.com > ~/bin/repo
chmod a+x ~/bin/repo

# Bind path tracking temporarily for this script execution session
export PATH=~/bin:$PATH

# 2. PROVISION 16GB VIRTUAL SWAP LAYER TO PROTECT LINK COMPILATION
echo "[*] Configuring a 16GB swap file to prevent server RAM saturation errors..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 16G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
else
    echo "[!] Active swap file already detected. Skipping creation."
fi

# 3. INITIALIZE WORKSPACE PATH DIRECTORIES
echo "[*] Creating master AOSP 8 source tree workspace layout..."
mkdir -p ~/android/aosp-8
cd ~/android/aosp-8

# 4. INITIALIZE REPO TRACKING CORE (ANDROID 8.1 OREO)
echo "[*] Initializing standard stable AOSP Oreo branch dependencies..."
# Running it with python3 ensures the modern repo infrastructure tool launches flawlessly
python3 ~/bin/repo init -u https://googlesource.com -b android-8.1.0_r81 --noprompt

# 5. INJECT CUSTOM D2ATT HARDWARE METADATA LOCAL MANIFEST
echo "[*] Injecting target Samsung Galaxy S3 AT&T platform dependencies..."
mkdir -p .repo/local_manifests

cat <<EOF > .repo/local_manifests/d2att.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <!-- S3 AT&T Specific Repositories -->
  <project name="LineageOS/android_device_samsung_d2att" path="device/samsung/d2att" remote="github" revision="cm-14.1" />
  <project name="LineageOS/android_kernel_samsung_d2att" path="kernel/samsung/d2att" remote="github" revision="cm-14.1" />

  <!-- Swap Standard AOSP Graphics/Audio for Legacy Qualcomm HALs -->
  <remove-project name="platform/hardware/qcom/display" />
  <remove-project name="platform/hardware/qcom/media" />
  <remove-project name="platform/hardware/qcom/audio" />
  
  <project name="LineageOS/android_hardware_qcom_display" path="hardware/qcom/display" remote="github" revision="lineage-15.1" />
  <project name="LineageOS/android_hardware_qcom_media" path="hardware/qcom/media" remote="github" revision="lineage-15.1" />
  <project name="LineageOS/android_hardware_qcom_audio" path="hardware/qcom/audio" remote="github" revision="lineage-15.1" />
</manifest>
EOF

# 6. RUN THE BULK DATA SYNCHRONIZATION OVER CHANNELS
echo "================================================================="
echo " ENV ARCHITECTURE ALLOCATED SUCCESSFULLY! STARTING DOWNLOAD."
echo " Fetching roughly 100GB-150GB of core raw platform codebase resources."
echo " This will take a long time depending on network connection..."
echo "================================================================="
python3 ~/bin/repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

echo "================================================================="
echo " DATA SYNC SUCESSFULLY ACCOMPLISHED!"
echo " Source code is staged and fully indexed inside ~/android/aosp-8"
echo "================================================================="

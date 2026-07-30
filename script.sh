#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# 4. FIX SYSTEM PYTHON INTERPRETER ALIASES
echo "[*] Mapping global Python alias paths (Python3 default, Python2 available)..."
sudo ln -sf /usr/bin/python3 /usr/local/bin/python
sudo ln -sf /usr/bin/python2 /usr/local/bin/python2

# 5. ALLOCATE 16GB VIRTUAL SWAP FILE TO PREVENT OUT-OF-MEMORY CRASHES
echo "[*] Setting up a 16GB swap file to protect server RAM during linkage phases..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 16G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
else
    echo "[!] Swapfile already exists. Skipping allocation."
fi

# 6. SETUP LOCAL BIN DIR AND FETCH GOOGLE REPO TOOL
echo "[*] Fetching Google Repo orchestration binary tool..."
mkdir -p ~/bin
curl https://googleapis.com > ~/bin/repo
chmod a+x ~/bin/repo

# Temporarily append ~/bin to the active path scope for the remainder of this script execution
export PATH=~/bin:$PATH

# 7. INITIALIZE THE WORKSPACE DIRECTORY
echo "[*] Creating workspace target directories..."
mkdir -p ~/android/aosp-8
cd ~/android/aosp-8

# 8. INITIALIZE REPO TRACKING CORE (ANDROID 8.1 OREO)
echo "[*] Launching repo init targeting Android 8.1 Oreo baseline..."
repo init -u https://googlesource.com -b android-8.1.0_r81 --noprompt

# 9. GENERATE THE LOCAL MANIFEST METADATA FILE FOR D2ATT
echo "[*] Injecting custom d2att hardware structure tree specifications..."
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

# 10. RUN THE INITIAL SYNCHRONIZATION DATA FETCH
echo "================================================================="
echo " CONFIGURATION COMPLETE! STARTING BASE SOURCE DOWNLOAD."
echo " This process downloads roughly 100GB-150GB of raw codebase files."
echo " Depending on internet speeds, this will take some time..."
echo "================================================================="
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

echo "================================================================="
echo " WORKSPACE SUCCESSFULLY ASSEMBLED AND SYNCHRONIZED!"
echo " Navigate to ~/android/aosp-8 to check downloaded trees."
echo "================================================================="

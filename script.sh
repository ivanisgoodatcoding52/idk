#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "================================================================="
echo "   COMMENCING CORRECTED WORKSPACE REPO SYNC FOR D2ATT"
echo "================================================================="

# 1. CONFIGURE WORKSPACE USER PATHS AND ENVIRONMENT POINTERS
echo "[*] Initializing ~/bin directory structure..."
mkdir -p ~/bin

# Download Google Repo launcher natively into your home profile path
curl https://googleapis.com > ~/bin/repo
chmod a+x ~/bin/repo

# Set up local shell path execution visibility 
export PATH=~/bin:$PATH

# 2. INLINE GIT CONFIGURATION (Resolves identity issues)
echo "[*] Configuring Git global identification profile..."
git config --global user.name "AOSP Builder"
git config --global user.email "builder@aosp.local"
git config --global color.ui false

# 3. SEPARATELY ENGAGE ROOT ACTIONS FOR VIRTUAL SWAP MEMORY
echo "[*] Checking virtual memory allocations..."
if [ ! -f /swapfile ]; then
    echo "[!] Requesting root authority to create 16GB compilation swap space..."
    sudo fallocate -l 16G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
else
    echo "[!] Active swap file already detected. Skipping."
fi

# 4. CONSTRUCT ENTIRE WORKSPACE STORAGE STRUCTURES
echo "[*] Creating master AOSP directory array..."
mkdir -p ~/android/aosp-8
cd ~/android/aosp-8

# Clean out any previous failed initialization remnants
rm -rf .repo

# 5. INITIALIZE REPO ENGINE (Using echo to safely bypass interactive prompts)
echo "[*] Initializing stable AOSP Oreo branch dependencies..."
echo | python3 ~/bin/repo init -u https://googlesource.com -b android-8.1.0_r81

# 6. GENERATE DEVICE-SPECIFIC LOCAL MANIFEST METADATA (WITH GITHUB REMOTE FIXED)
echo "[*] Injecting Samsung Galaxy S3 AT&T (d2att) custom device mapping data..."
mkdir -p .repo/local_manifests

cat <<EOF > .repo/local_manifests/d2att.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <!-- EXPLICITLY DEFINE GITHUB REMOTE SO AOSP UNDERSTANDS WHERE TO FETCH -->
  <remote name="github" fetch="https://github.com" />

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

# 7. TRIGGER THE BULK USER-LEVEL PARALLEL SOURCE CODE DOWNLOAD
echo "================================================================="
echo " CONFIGURATION SUCCESSFUL! STARTING NATIVE SYSTEM REPO SYNC."
echo " Fetching roughly 100GB-150GB of core raw platform codebase resources."
echo " Running completely via standard user space threads to bypass locks."
echo "================================================================="
python3 ~/bin/repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

echo "================================================================="
echo " DATA SYNC SUCCESSFUL!"
echo " Source code is staged and fully indexed inside ~/android/aosp-8"
echo "================================================================="

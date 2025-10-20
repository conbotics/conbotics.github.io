#!/bin/bash
set -e

# === CONFIGURATION ===
BOARD="jetson-orin-nano-devkit"
EXTERNAL_DEVICE="nvme0n1p1"
KEY_FILE="./sym2_t234.key"
QSPI_CONFIG="bootloader/t186ref/cfg/flash_t234_qspi.xml"
NVME_CONFIG="./tools/kernel_flash/flash_l4t_t234_nvme_rootfs_enc.xml"
EKS_IMG="bootloader/eks_t234_sigheader.img.encrypt"
ROOTFS_SIZE="400GiB"
EXT_NUM_SECTORS="850000000"

# === STEP 1: Prepare internal flash layout (no actual flashing) ===
echo "Step 1: Preparing internal flash layout..."
sudo ./tools/kernel_flash/l4t_initrd_flash.sh \
    --network usb0 \
    --no-flash \
    --showlogs \
    -p "-c ${QSPI_CONFIG}" \
    ${BOARD} internal
echo "✅ Internal flash layout prepared successfully."

# === STEP 2: Generate encrypted key storage image (EKS) ===
echo "Step 2: Generating EKS image..."
sudo ./flash.sh --no-flash -k A_eks ${BOARD} internal
echo "✅ EKS image generated successfully."

# === STEP 3: Copy EKS to kernel flash image tree ===
echo "Step 3: Copying EKS image to kernel flash image directory..."
sudo cp ${EKS_IMG} ./tools/kernel_flash/images/internal/.
echo "✅ EKS image copied successfully."

# === STEP 4: Prepare encrypted rootfs on NVMe and flash ===
echo "Step 4: Preparing encrypted rootfs on NVMe..."
sudo EXT_NUM_SECTORS=${EXT_NUM_SECTORS} ROOTFS_ENC=1 ./tools/kernel_flash/l4t_initrd_flash.sh \
        --showlogs \
        --external-device ${EXTERNAL_DEVICE} \
        -S ${ROOTFS_SIZE} \
        -i ${KEY_FILE} \
        -c ${NVME_CONFIG} \
        --external-only \
        --append \
        --network usb0 \
        ${BOARD} external

echo "✅ Flashing complete with encrypted NVMe rootfs."

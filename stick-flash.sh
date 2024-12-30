#!/bin/bash

# diskutil list | grep /dev/disk
# ^^df -h

# Variables
IMAGE_PATH="/Volumes/HOME-STORE/Desktop/bluewavestudio-openauto-pro-release-16.1.img"
USB_DEVICE="/dev/disk4" # Replace with your USB device identifier
BLOCKSIZE="4M"

# Ensure the script is run with superuser privileges
# if [ "$EUID" -ne 0 ]; then
#     echo "Please run as root"
#     exit 1
# fi

# Confirm the USB device
# echo "This will erase all data on $USB_DEVICE. Are you sure? (yes/no)"
# read confirmation
# if [ "$confirmation" != "yes" ]; then
#     echo "Operation cancelled."
#     exit 1
# fi

# Unmount the USB device
echo "Unmounting $USB_DEVICE..."
umount ${USB_DEVICE}* || diskutil unmountDisk $USB_DEVICE &&

# # Flash the OS image to the USB stick
echo "Flashing $IMAGE_PATH to $USB_DEVICE ..."

# gzip -dc $IMAGE_PATH | dd of="$USB_DEVICE" bs="$BLOCKSIZE" status=progress conv=fsync
dd if="$IMAGE_PATH" of="$USB_DEVICE" bs="$BLOCKSIZE" status=progress conv=fsync
if [ $? -ne 0 ]; then
    echo "An error occurred while flashing the image."
    exit 1
else
    echo "Flashing complete." &&
        # # Sync the filesystem
        echo "Syncing filesystem..." &&
        sync &&
        # # Eject the USB stick
        echo "Ejecting $USB_DEVICE..."
    # eject $USB_DEVICE ||
    diskutil eject $USB_DEVICE &&
        echo "Flashing complete. You can now remove the USB stick."
fi

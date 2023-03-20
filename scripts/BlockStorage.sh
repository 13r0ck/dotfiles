#!/bin/sh

# README:
# A Simple Script to add Vultr BlockStorage to a sever

## CONFIG

PATH="/dev/vdb"

## END CONFIG

# Check if script is being run as root or with sudo
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root or with sudo"
    exit 1
fi

echo "Make sure your have attached the Block Storage to this server in the Vultr management console."
read -p "Press [ENTER] to continue..."

parted -s /dev/vdb mklabel gpt
parted -s /dev/vdb unit mib mkpart primary 0% 100%
mkfs.ext4 /dev/vdb1
mkdir /mnt/blockstorage
echo /dev/vdb1 /mnt/blockstorage ext4 defaults,noatime,nofail 0 0 >> /etc/fstab
mount /mnt/blockstorage

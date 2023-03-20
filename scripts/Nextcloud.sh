#!/bin/bash

# README:
# A Simple Script to add Vultr BlockStorage to a sever

## CONFIG

DOMAIN=""
EMAIL=""
USERNAME=""
PASSWORD=""
DATA_LOCATION=""

## END CONFIG

# Check if script is being run as root or with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo"
    exit 1
fi

echo "Make sure you have set your IaaS prover's firewall settings to allow port 80 and 443."
read -pr "Press [ENTER] to continue..." null
echo "You need a domain pointed at your server. An IP address isn't good enough for this script."
read -pr "Press [ENTER] to continue..." null

echo "Use alternate directory?"
echo "If using /script/BlockStorage.sh this value is '/mnt/blockstorage/nextcloud'"
read -pr "USe alternate data directory? (Path in '/mnt' or empty to use default): " DATA_LOCATION

if [ -z "$DOMAIN" ];then
  read -pr "Domain (example.com): " DOMAIN
fi

if [ -z "$EMAIL" ]; then
  read -pr "Email (email@example.com): " EMAIL
fi

if [ -z "$USERNAME" ]; then
  read -pr "Nextcloud Admin username: " USERNAME
fi

if [ -z "$PASSWORD" ]; then
  read -pr "Nextcloud admin password: " PASSWORD
fi

sudo snap install nextcloud

if [ -z "$DATA_LOCATION" ]; then
  sudo snap connect nextcloud:removable-media
  mkdir -p "$DATA_LOCATION"
  sed -i "s/'directory' => getenv('NEXTCLOUD_DATA_DIR'),/'directory' => '${DATA_LOCATION}',/" \
    /var/snap/nextcloud/current/nextcloud/config/autoconfig.php
  sudo mkdir -p "$DATA_LOCATION"
  sudo chown -R root:root "$DATA_LOCATION"
  sudo chmod 0770 "$DATA_LOCATION"
fi

sudo nextcloud.manual-install "$USERNAME" "$PASSWORD"
sudo nextcloud.occ config:system:set trusted_domains 1 --value="$DOMAIN"
sudo ufw allow 80,443/tcp
sudo nextcloud.enable-https lets-encrypt

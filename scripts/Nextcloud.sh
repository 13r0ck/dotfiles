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
echo "Press [ENTER] to continue..."
read null
echo "You need a domain pointed at your server. An IP address isn't good enough for this script."
echo "Press [ENTER] to continue..."
read null

echo "Use alternate directory?"
echo "If using /script/BlockStorage.sh this value is '/mnt/blockstorage/nextcloud'"
echo "USe alternate data directory? (Path in '/mnt' or empty to use default): "
read DATA_LOCATION

if [ -z "$DATA_LOCATION" ]; then
  DATA_LOCATION=${DATA_LOCATION//\//\\/} # Make path safe for sed
fi

if [ -z "$DOMAIN" ];then
  echo "Domain (example.com): "
  read DOMAIN
fi

if [ -z "$EMAIL" ]; then
  echo "Email (email@example.com): "
  read EMAIL
fi

if [ -z "$USERNAME" ]; then
  echo "Nextcloud Admin username: "
  read USERNAME
fi

if [ -z "$PASSWORD" ]; then
  echo "Nextcloud admin password: "
  read PASSWORD
fi

# Install nextcloud and related dependencies
sudo snap install nextcloud
snap install --edge imagick

# Configure nexcloud
if [ -z "$DATA_LOCATION" ]; then
  sudo snap connect nextcloud:removable-media
  mkdir -p "$DATA_LOCATION"
  sed -i "s/'directory' => getenv('NEXTCLOUD_DATA_DIR'),/'directory' => '${DATA_LOCATION}',/" \
    /var/snap/nextcloud/current/nextcloud/config/autoconfig.php
  sudo mkdir -p "$DATA_LOCATION"
  sudo chown -R root:root "$DATA_LOCATION"
  sudo chmod 0770 "$DATA_LOCATION"
fi

# Install and create admin user
sudo nextcloud.manual-install "$USERNAME" "$PASSWORD"
sudo nextcloud.occ config:system:set trusted_domains 1 --value="$DOMAIN"
sudo ufw allow 80,443/tcp
sudo nextcloud.enable-https lets-encrypt

# Enable Encryption
sudo nextcloud.occ app:install encryption
sudo nextcloud.occ app:enable encryption
sudo nextcloud.occ encryption:enable

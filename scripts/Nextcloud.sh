#!/bin/sh

# README:
# A Simple Script to add Vultr BlockStorage to a sever

## CONFIG

DOMAIN=""
EMAIL=""
USERNAME=""
PASSWORD=""

## END CONFIG

# Check if script is being run as root or with sudo
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root or with sudo"
    exit 1
fi

if [ -n "$DOMAIN" ];then
  read -p "Domain (example.com): " DOMAIN
fi

if [ -n "$EMAIL" ]; then
  read -p "Email (email@example.com): " EMAIL
fi

if [ -n "$USERNAME" ]; then
  read -p "Nextcloud Admin username: " USERNAME
fi

if [ -n "$PASSWORD" ]; then
  read -p "Nextcloud admin password: " PASSWORD
fi

echo "Make sure you have set your IaaS prover's firewall settings to allow port 80 and 443."
read -p "Press [ENTER] to continue..." null
echo "You need a domain pointed at your server. An IP address isn't good enough for this script."
read -p "Press [ENTER] to continue..." null

sudo snap install nextcloud
sudo nextcloud.manual-install $USERNAME $PASSWORD
sudo nextcloud.occ config:system:set trusted_domains 1 --value=$DOMAIN
sudo ufw allow 80,443/tcp
sudo nextcloud.enable-https lets-encrypt

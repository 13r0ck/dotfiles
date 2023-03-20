#!/bin/sh

# This script is just a simple server init for ssh access with public
# Key. I modify the variables on top and then upload the script to
# A cloud hosting provider (for example Vultr)

## CONFIG

USERNAME=username
DEFAULT_PASS="password" # Requires change once logged in
PUBLIC_KEY="sk-ssh-ed25519@openssh.com AAAA... email@example.com"

## END CONFIG

if ! grep -q "^$USERNAME:" /etc/passwd; then
  sudo useradd -d /home/$USERNAME -m -s/bin/bash $USERNAME
  echo "$USERNAME:$DEFAULT_PASS" | chpasswd
  chage -d 0 $USERNAME
  usermod -aG sudo $USERNAME
  sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config


  if [ -n "$PUBLIC_KEY" ]; then
      mkdir -p /home/$USERNAME/.ssh
      echo "$PUBLIC_KEY" >> /home/$USERNAME/.ssh/authorized_keys

      # Set ownership of home directory and SSH directory to the new user
      chown -R $USERNAME:$USERNAME /home/$username
      sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  fi
fi

#!/bin/bash

# Enable swap
sudo fallocate -l 8G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# cd /tmp
cd /home/ubuntu

# Update, Upgrade and Packages Installing
apt-get -yqq update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Hostname
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
hostnamectl set-hostname ${function}-$INSTANCE_ID

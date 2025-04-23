#!/bin/bash

set -e  # Exit on error

# Remove LibreOffice
sudo apt-get purge libreoffice* -y
sudo apt-get autoremove -y
sudo apt-get clean

# Fix sudoers safely
echo "jsaintho ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jsaintho

# Update and install dependencies
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y make curl lsb-release ca-certificates apt-transport-https software-properties-common

# Docker setup
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs | tail -n 1) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-compose docker-compose-plugin

# Create directories
USER_HOME=$(getent passwd $(logname) | cut -d: -f6)

mkdir -p "$USER_HOME/data/wordpress"
mkdir -p "$USER_HOME/data/mariadb"

echo "Data directories set up successfully."

# Add user to docker group
sudo usermod -aG docker $(logname)
echo "User $(logname) added to Docker group."

sudo chmod 666 /var/run/docker.sock

echo "✅ Setup complete!"


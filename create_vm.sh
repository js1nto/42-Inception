#!/bin/bash

set -e  # Exit on error

# Remove LibreOffice
sudo apt-get purge libreoffice* -y
sudo apt-get autoremove -y
sudo apt-get clean

# Fix sudoers safely
#su -
#echo "jsaintho ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jsaintho

# Update and install dependencies
sudo apt-get update

echo "Installing Docker..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Creating Docker repository file..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker packages..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker installed successfully!"

# Add user to docker group
sudo usermod -aG docker $(logname)
echo "User $(logname) added to Docker group."

# INSTALL WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Set Docker socket permissions (not always recommended, consider alternatives)
sudo chmod 666 /var/run/docker.sock

echo "✅ Setup complete!"


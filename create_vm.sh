#!/bin/bash

# Set your actual username here
USERNAME="jsaintho"

# Ensure the script is run with sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with sudo:"
  echo "sudo $0"
  exit 1
fi

echo "Configuring sudoers for $USERNAME..."

# Backup sudoers first
cp /etc/sudoers /etc/sudoers.bak

# Add user to sudoers without password
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

# Add user to sudo group
usermod -aG sudo "$USERNAME"

# System update
echo "Updating the system..."
apt-get update -y && apt-get upgrade -y

# Install basic tools
apt-get install -y make curl gnupg lsb-release ca-certificates

# Add Docker’s official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
apt-get update -y

# Install Docker Engine and tools
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the user to the docker group
usermod -aG docker "$USERNAME"
echo "User $USERNAME added to docker group."

echo "✅ Setup complete! You may need to reboot for all changes to take effect."

#!/bin/bash

su -

sudo usermod -aG sudo $(whoami)

echo "
# User privilege specification
root ALL=(ALL:ALL) ALL
jsaintho ALL=(ALL:ALL) NOPASSWD: ALL
" >/etc/sudoers


sudo apt-get update -y && apt-get upgrade
sudo apt-get install make curl

echo "Installing Docker..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Creating Docker repository file..."
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker packages..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker installed successfully!"

sudo usermod -aG docker $(whoami)
echo "User $(whoami) added to Docker group."

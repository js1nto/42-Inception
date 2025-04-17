#!/bin/bash

su -

echo "
# User privilege specification
root ALL=(ALL:ALL) ALL
jsaintho ALL=(ALL:ALL) NOPASSWD: ALL
" >/etc/sudoers

usermod -aG sudo <your_nickname>

sudo apt-get update -y && apt-get upgrade
sudo apt-get install make curl

echo "Installing Docker..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Creating Docker repository file..."
echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker packages..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker installed successfully!"

sudo usermod -aG docker $(USER)
echo "User $(USER) added to Docker group."

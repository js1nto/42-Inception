#!/bin/bash
set -e  # Exit on error

#su -
#echo "jsaintho ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jsaintho
# su -
# echo "127.0.0.1  juless.42.fr" >> /etc/hosts

# Remove LibreOffice
sudo apt-get purge libreoffice* -y
sudo apt-get autoremove -y
sudo apt-get clean

# Update and install dependencies
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker
echo "🔧 Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "✅ Docker installed."

# Add user to docker group
sudo usermod -aG docker $(logname)
echo "👤 User $(logname) added to docker group. Please log out and log back in or run 'newgrp docker' to apply."

# Install WP-CLI
if ! command -v wp &> /dev/null; then
  echo "📦 Installing WP-CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
  echo "✅ WP-CLI installed."
else
  echo "ℹ️ WP-CLI already installed."
fi

echo "🎉 Setup complete. Remember to log out and log back in for Docker group changes to take effect."
exec sg docker newgrp `id -gn`


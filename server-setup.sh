#!/bin/bash

# Update and upgrade the system packages
sudo apt update
sudo apt upgrade -y

# Install essential packages
sudo apt install -y git gnupg curl build-essential

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Load NVM into the current shell session
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Install Node.js using NVM
nvm install --lts

# Install MongoDB

# Import the MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload local package database
sudo apt-get update

# Install the MongoDB packages
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod

# Enable MongoDB to start on boot
sudo systemctl enable mongod

# Install pm2 globally for Node.js process management
npm install -g pm2

# Install and configure UFW (Uncomplicated Firewall)
sudo apt install -y ufw
# Allow SSH connections
sudo ufw allow ssh
# Allow Nginx traffic through the firewall
sudo ufw allow 'Nginx Full'
# Enable UFW
sudo ufw enable

# Install Nginx
sudo apt install -y nginx

# Optional: Install Certbot for SSL certificates
sudo apt install -y certbot python3-certbot-nginx

# Reload UFW to apply rules
sudo ufw reload

# Check service status
sudo systemctl status mongod
sudo systemctl status nginx

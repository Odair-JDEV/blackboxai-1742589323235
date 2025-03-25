#!/bin/bash

echo "🚀 Starting installation process..."

# Update package list
echo "📦 Updating package list..."
sudo apt-get update

# Install Node.js and npm
echo "🟢 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install MongoDB
echo "🍃 Installing MongoDB..."
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB service
echo "🔄 Starting MongoDB service..."
sudo systemctl start mongod
sudo systemctl enable mongod

# Install project dependencies
echo "📚 Installing project dependencies..."

# Backend dependencies
echo "⚙️ Installing backend dependencies..."
cd backend
npm install

# Frontend dependencies
echo "🎨 Installing frontend dependencies..."
cd ../frontend
npm install

# Set permissions
echo "🔒 Setting permissions..."
cd ..
chmod -R 777 .

echo "✅ Installation completed successfully!"
echo "
MongoDB service status:"
sudo systemctl status mongod

echo "
Node.js version:"
node --version

echo "
npm version:"
npm --version

echo "
🎉 Your development environment is ready!"
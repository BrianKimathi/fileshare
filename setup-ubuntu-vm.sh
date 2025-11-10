#!/bin/bash
# setup-ubuntu-vm.sh
# Script to set up the backend on Ubuntu VM for testing

echo "========================================="
echo "GepHub VPN Backend Setup for Ubuntu VM"
echo "========================================="

# Update system
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Java 17
echo "Installing Java 17..."
sudo apt-get install -y openjdk-17-jdk
java -version

# Install Maven
echo "Installing Maven..."
sudo apt-get install -y maven
mvn -version

# Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
echo "Setting up PostgreSQL database..."
sudo -u postgres psql << EOF
CREATE DATABASE gephubvpn;
CREATE USER gephubuser WITH PASSWORD 'gephubpass123';
ALTER ROLE gephubuser SET client_encoding TO 'utf8';
ALTER ROLE gephubuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE gephubuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE gephubvpn TO gephubuser;
\q
EOF

echo "PostgreSQL setup complete!"
echo "Database: gephubvpn"
echo "User: gephubuser"
echo "Password: gephubpass123"

# Install Git (if not already installed)
sudo apt-get install -y git

# Install net-tools for network utilities
sudo apt-get install -y net-tools

# Configure firewall (allow port 8080)
echo "Configuring firewall..."
sudo ufw allow 8080/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable

echo "========================================="
echo "Setup complete!"
echo "========================================="
echo "Next steps:"
echo "1. Update application.properties with database credentials"
echo "2. Copy your backend code to this VM"
echo "3. Run: cd gephub-vpn && mvn spring-boot:run"
echo "========================================="


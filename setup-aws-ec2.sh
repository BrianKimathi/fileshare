#!/bin/bash
# setup-aws-ec2.sh
# Script to set up EC2 instance for production deployment

echo "========================================="
echo "GepHub VPN Backend - AWS EC2 Setup"
echo "========================================="

# Update system
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Java 17
echo "Installing Java 17..."
sudo apt-get install -y openjdk-17-jdk
java -version

# Install PostgreSQL client (for connecting to RDS)
echo "Installing PostgreSQL client..."
sudo apt-get install -y postgresql-client

# Create application directory
echo "Creating application directory..."
sudo mkdir -p /opt/gephub-vpn
sudo chown ubuntu:ubuntu /opt/gephub-vpn

# Create logs directory
sudo mkdir -p /var/log/gephub-vpn
sudo chown ubuntu:ubuntu /var/log/gephub-vpn

# Configure firewall
echo "Configuring firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Install Nginx (for reverse proxy - optional)
echo "Installing Nginx..."
sudo apt-get install -y nginx

echo "========================================="
echo "EC2 Setup complete!"
echo "========================================="
echo "Next steps:"
echo "1. Upload your JAR file and application.properties"
echo "2. Create systemd service (see gephub-vpn.service)"
echo "3. Start the service: sudo systemctl start gephub-vpn"
echo "========================================="


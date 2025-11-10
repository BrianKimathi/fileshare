#!/bin/bash
# setup-wireguard-server.sh
# Script to set up WireGuard VPN server on Ubuntu Linux (Recommended - Easier and Faster)

echo "========================================="
echo "WireGuard VPN Server Setup for GepHub VPN"
echo "========================================="

# Update system
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install WireGuard
echo "Installing WireGuard..."
sudo apt-get install -y wireguard wireguard-tools

# Enable IP forwarding
echo "Enabling IP forwarding..."
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

# Generate server keys
echo "Generating server keys..."
cd /etc/wireguard
sudo wg genkey | sudo tee server_private.key | sudo wg pubkey | sudo tee server_public.key
sudo chmod 600 server_private.key

# Get server IP
SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
SERVER_PRIVATE_KEY=$(sudo cat server_private.key)
SERVER_PUBLIC_KEY=$(sudo cat server_public.key)

# Create server configuration
echo "Creating WireGuard server configuration..."
sudo tee /etc/wireguard/wg0.conf > /dev/null <<EOF
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Add client configurations here
# [Peer]
# PublicKey = CLIENT_PUBLIC_KEY
# AllowedIPs = 10.0.0.2/32
EOF

# Configure firewall
echo "Configuring firewall..."
sudo ufw allow 51820/udp
sudo ufw allow OpenSSH
sudo ufw --force enable

# Enable WireGuard service
echo "Enabling WireGuard service..."
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service

# Check status
echo "Checking WireGuard status..."
sudo systemctl status wg-quick@wg0.service --no-pager
sudo wg show

echo ""
echo "========================================="
echo "WireGuard Server Setup Complete!"
echo "========================================="
echo "Server IP: $SERVER_IP"
echo "Port: 51820"
echo "Protocol: UDP"
echo "Server Public Key: $SERVER_PUBLIC_KEY"
echo ""
echo "To add a client:"
echo "1. Generate client keys:"
echo "   wg genkey | tee client_private.key | wg pubkey | tee client_public.key"
echo "2. Add to server config:"
echo "   sudo wg set wg0 peer CLIENT_PUBLIC_KEY allowed-ips 10.0.0.2/32"
echo "3. Create client config file"
echo "4. Update Android app with server IP: $SERVER_IP"
echo "========================================="


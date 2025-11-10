#!/bin/bash
# generate-client-config.sh
# Script to generate WireGuard client configuration for Android

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <client_name> <client_ip>"
    echo "Example: $0 android_client 10.0.0.2"
    exit 1
fi

CLIENT_NAME=$1
CLIENT_IP=$2

echo "========================================="
echo "Generating WireGuard Client Configuration"
echo "========================================="

# Generate client keys
echo "Generating client keys..."
wg genkey | tee ${CLIENT_NAME}_private.key | wg pubkey | tee ${CLIENT_NAME}_public.key
CLIENT_PRIVATE_KEY=$(cat ${CLIENT_NAME}_private.key)
CLIENT_PUBLIC_KEY=$(cat ${CLIENT_NAME}_public.key)

# Get server details
SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
SERVER_PUBLIC_KEY=$(sudo cat /etc/wireguard/server_public.key)
SERVER_PORT=51820

# Create client configuration
echo "Creating client configuration file..."
cat > ${CLIENT_NAME}.conf <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP/24
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_IP:$SERVER_PORT
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

# Add client to server
echo "Adding client to WireGuard server..."
sudo wg set wg0 peer $CLIENT_PUBLIC_KEY allowed-ips $CLIENT_IP/32

# Save server configuration
sudo wg-quick save wg0

echo ""
echo "========================================="
echo "Client Configuration Generated!"
echo "========================================="
echo "Client Name: $CLIENT_NAME"
echo "Client IP: $CLIENT_IP"
echo "Client Public Key: $CLIENT_PUBLIC_KEY"
echo ""
echo "Configuration file: ${CLIENT_NAME}.conf"
echo ""
echo "To use in Android app:"
echo "1. Copy ${CLIENT_NAME}.conf content"
echo "2. Use WireGuard Android app or implement WireGuard library"
echo "3. Server IP: $SERVER_IP"
echo "========================================="

# Display QR code (if qrencode is installed)
if command -v qrencode &> /dev/null; then
    echo ""
    echo "QR Code for easy import:"
    qrencode -t ANSI < ${CLIENT_NAME}.conf
fi


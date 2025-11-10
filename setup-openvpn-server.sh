#!/bin/bash
# setup-openvpn-server.sh
# Script to set up OpenVPN server on Ubuntu Linux

echo "========================================="
echo "OpenVPN Server Setup for GepHub VPN"
echo "========================================="

# Update system
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install OpenVPN and Easy-RSA
echo "Installing OpenVPN and Easy-RSA..."
sudo apt-get install -y openvpn easy-rsa

# Create directory for PKI
echo "Setting up PKI directory..."
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

# Initialize PKI
echo "Initializing PKI..."
./easyrsa init-pki
./easyrsa --batch build-ca nopass

# Build server certificate
echo "Building server certificate..."
./easyrsa --batch build-server-full server nopass

# Generate Diffie-Hellman parameters
echo "Generating DH parameters (this may take a while)..."
./easyrsa gen-dh

# Generate TLS-Auth key
echo "Generating TLS-Auth key..."
openvpn --genkey --secret pki/ta.key

# Create server configuration directory
echo "Creating server configuration..."
sudo mkdir -p /etc/openvpn/server
sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem pki/ta.key /etc/openvpn/server/

# Create server configuration file
echo "Creating OpenVPN server configuration..."
sudo tee /etc/openvpn/server/server.conf > /dev/null <<EOF
port 1194
proto udp
dev tun
ca /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/server.crt
key /etc/openvpn/server/server.key
dh /etc/openvpn/server/dh.pem
tls-auth /etc/openvpn/server/ta.key 0
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist /var/log/openvpn/ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
auth SHA256
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
verb 3
explicit-exit-notify 1
EOF

# Enable IP forwarding
echo "Enabling IP forwarding..."
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

# Configure firewall
echo "Configuring firewall..."
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH
sudo ufw --force enable

# Configure NAT (if using UFW)
echo "Configuring NAT..."
sudo sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sudo ufw reload

# Add iptables rules for NAT
echo "Adding iptables NAT rules..."
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
sudo iptables-save | sudo tee /etc/iptables.rules > /dev/null

# Create iptables restore script
sudo tee /etc/network/if-up.d/iptables > /dev/null <<'EOF'
#!/bin/bash
iptables-restore < /etc/iptables.rules
EOF
sudo chmod +x /etc/network/if-up.d/iptables

# Create log directory
sudo mkdir -p /var/log/openvpn
sudo chown nobody:nogroup /var/log/openvpn

# Enable and start OpenVPN
echo "Enabling OpenVPN service..."
sudo systemctl enable openvpn-server@server.service
sudo systemctl start openvpn-server@server.service

# Check status
echo "Checking OpenVPN status..."
sudo systemctl status openvpn-server@server.service --no-pager

# Get server IP
SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
echo ""
echo "========================================="
echo "OpenVPN Server Setup Complete!"
echo "========================================="
echo "Server IP: $SERVER_IP"
echo "Port: 1194"
echo "Protocol: UDP"
echo ""
echo "Next steps:"
echo "1. Generate client certificates:"
echo "   cd ~/openvpn-ca"
echo "   ./easyrsa build-client-full client1 nopass"
echo "2. Create client configuration file"
echo "3. Update Android app with server IP: $SERVER_IP"
echo "========================================="


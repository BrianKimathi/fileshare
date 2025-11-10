# VPN Server Setup Guide

## Overview

This guide helps you set up a VPN server on Ubuntu Linux for GepHub VPN. We recommend **WireGuard** as it's faster, more secure, and easier to configure than OpenVPN.

## Option 1: WireGuard (Recommended)

### Advantages
- ✅ Faster performance
- ✅ Modern cryptography
- ✅ Easier to configure
- ✅ Lower battery usage on mobile
- ✅ Better for mobile networks

### Setup Steps

1. **Run setup script:**
   ```bash
   chmod +x setup-wireguard-server.sh
   ./setup-wireguard-server.sh
   ```

2. **Generate client configuration:**
   ```bash
   chmod +x generate-client-config.sh
   ./generate-client-config.sh android_client 10.0.0.2
   ```

3. **Note the server details:**
   - Server IP: (shown in output)
   - Port: 51820
   - Server Public Key: (shown in output)

4. **Update Android app:**
   - Use server IP in VPN connection
   - Port: 51820
   - Protocol: WireGuard

## Option 2: OpenVPN

### Advantages
- ✅ More mature
- ✅ Better compatibility
- ✅ More documentation

### Setup Steps

1. **Run setup script:**
   ```bash
   chmod +x setup-openvpn-server.sh
   ./setup-openvpn-server.sh
   ```

2. **Generate client certificate:**
   ```bash
   cd ~/openvpn-ca
   ./easyrsa build-client-full android_client nopass
   ```

3. **Create client configuration:**
   ```bash
   # Copy client certificate and key
   # Create android_client.ovpn file
   ```

4. **Update Android app:**
   - Use server IP in VPN connection
   - Port: 1194
   - Protocol: OpenVPN

## Android Implementation

### For WireGuard

You'll need to use the WireGuard library or integrate with WireGuard Android app.

### For OpenVPN

Use OpenVPN library for Android or implement custom VPN service.

## Testing

### Test Server Connectivity
```bash
# Check WireGuard status
sudo wg show

# Check OpenVPN status
sudo systemctl status openvpn-server@server.service

# Test port
sudo netstat -tulpn | grep 51820  # WireGuard
sudo netstat -tulpn | grep 1194   # OpenVPN
```

### Test from Android
1. Connect to VPN from app
2. Check if IP changes
3. Verify internet connectivity
4. Check VPN status in notification

## Troubleshooting

### WireGuard Issues
```bash
# Check logs
sudo journalctl -u wg-quick@wg0 -f

# Restart service
sudo systemctl restart wg-quick@wg0

# Check interface
sudo ip addr show wg0
```

### OpenVPN Issues
```bash
# Check logs
sudo tail -f /var/log/openvpn/openvpn-status.log

# Restart service
sudo systemctl restart openvpn-server@server.service

# Check connections
sudo cat /var/log/openvpn/openvpn-status.log
```

### Firewall Issues
```bash
# Check firewall status
sudo ufw status

# Allow VPN port
sudo ufw allow 51820/udp  # WireGuard
sudo ufw allow 1194/udp   # OpenVPN
```

## Security Notes

1. **Change default ports** (optional but recommended)
2. **Use strong keys** (automatically generated)
3. **Limit client IPs** in server config
4. **Use firewall** to restrict access
5. **Regular updates**: `sudo apt-get update && sudo apt-get upgrade`

## Integration with Backend

The backend should:
1. Store VPN server configurations (IP, port, keys)
2. Provide server details to authenticated clients
3. Track active connections
4. Manage client certificates/keys

## Next Steps

1. Set up VPN server on Ubuntu VM or AWS EC2
2. Generate client configurations
3. Update Android app to use real VPN connection
4. Test end-to-end connection
5. Deploy to production


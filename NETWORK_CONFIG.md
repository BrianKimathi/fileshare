# Network Configuration Guide

## Finding IP Addresses

### Ubuntu VM
```bash
# Get IP address
hostname -I
# or
ip addr show | grep "inet "

# Get all network interfaces
ip addr show
```

### AWS EC2
```bash
# Get public IP (from AWS Console)
# EC2 Dashboard → Instances → Your Instance → Public IPv4 address

# Get private IP (from EC2 instance)
hostname -I
```

## Firewall Configuration

### Ubuntu VM (UFW)
```bash
# Check status
sudo ufw status

# Allow ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # Backend API
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# Enable firewall
sudo ufw enable

# Check rules
sudo ufw status numbered
```

### AWS Security Groups
1. Go to EC2 → Security Groups
2. Select your security group
3. Edit Inbound Rules:
   - SSH (22) from your IP
   - Custom TCP (8080) from anywhere (or your IP)
   - HTTP (80) from anywhere
   - HTTPS (443) from anywhere

## Testing Connectivity

### From Host Machine to VM
```bash
# Test SSH
ssh user@vm-ip

# Test API
curl http://vm-ip:8080/api/actuator/health

# Test with timeout
curl --connect-timeout 5 http://vm-ip:8080/api/actuator/health
```

### From Android App
1. Ensure phone and VM/EC2 are on same network (for VM) or internet accessible (for EC2)
2. Update API base URL in Android app:
   ```kotlin
   val BASE_URL = "http://VM_IP:8080/api"
   // or
   val BASE_URL = "http://EC2_PUBLIC_IP:8080/api"
   ```

## Common Network Issues

### Can't Connect from Host to VM
- Check VM firewall: `sudo ufw status`
- Check VM is running: `ping vm-ip`
- Check port is listening: `sudo netstat -tulpn | grep 8080`
- Check VM network adapter is bridged/NAT

### Can't Connect from Android to Backend
- Check backend is running: `curl http://localhost:8080/api/actuator/health`
- Check firewall allows port 8080
- Check IP address is correct
- Check Android app has INTERNET permission
- Check phone and backend are on same network (for VM)

### AWS EC2 Not Accessible
- Check security group allows port 8080
- Check EC2 instance is running
- Check application is running: `sudo systemctl status gephub-vpn`
- Check public IP is correct
- Check route table allows internet access


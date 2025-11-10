# GepHub VPN Backend - Deployment Guide

## Table of Contents
1. [Local Ubuntu VM Testing](#local-ubuntu-vm-testing)
2. [AWS Deployment](#aws-deployment)
3. [Troubleshooting](#troubleshooting)

---

## Local Ubuntu VM Testing

### Prerequisites
- Ubuntu 20.04 or 22.04 VM
- At least 2GB RAM
- Internet connection

### Step 1: Run Setup Script
```bash
chmod +x setup-ubuntu-vm.sh
./setup-ubuntu-vm.sh
```

### Step 2: Configure Application
```bash
cd gephub-vpn
cp application-vm.properties src/main/resources/application.properties
# Edit application.properties with your email settings
```

### Step 3: Build and Run
```bash
mvn clean package -DskipTests
java -jar target/gephub-vpn-0.0.1-SNAPSHOT.jar
```

### Step 4: Test API
```bash
# Test registration
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'

# Test login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "usernameOrEmail": "testuser",
    "password": "password123"
  }'
```

### Step 5: Find VM IP Address
```bash
# On Ubuntu VM
hostname -I
# or
ip addr show
```

### Step 6: Access from Host Machine
Update your Android app's API base URL to:
```
http://YOUR_VM_IP:8080/api
```

---

## AWS Deployment

### Prerequisites
- AWS Account
- AWS CLI configured (optional)
- EC2 Key Pair created

### Step 1: Create RDS PostgreSQL Database

1. Go to AWS Console → RDS → Create Database
2. Select PostgreSQL
3. Configuration:
   - Template: Free tier
   - DB instance identifier: `gephub-vpn-db`
   - Master username: `postgres`
   - Master password: [Strong password]
   - DB instance class: `db.t3.micro`
   - Storage: 20 GB
   - VPC: Default or create new
   - Public access: Yes (for testing)
   - Security group: Create new or use existing
4. Click "Create Database"
5. Wait for database to be available
6. Note the endpoint URL

### Step 2: Configure RDS Security Group

1. Go to RDS → Your Database → Connectivity & Security
2. Click on Security Group
3. Edit Inbound Rules:
   - Type: PostgreSQL
   - Port: 5432
   - Source: Your EC2 Security Group ID

### Step 3: Create EC2 Instance

1. Go to AWS Console → EC2 → Launch Instance
2. Configuration:
   - Name: `gephub-vpn-backend`
   - AMI: Ubuntu Server 22.04 LTS
   - Instance type: `t2.micro` or `t3.small`
   - Key pair: Select your key pair
   - Network settings:
     - Allow SSH (22)
     - Allow HTTP (80)
     - Allow HTTPS (443)
     - Create security group: `gephub-vpn-sg`
     - Add custom rule: TCP 8080 from anywhere (or your IP)
3. Launch Instance
4. Note the Public IP address

### Step 4: Connect to EC2

```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### Step 5: Set Up EC2 Instance

```bash
# On EC2 instance
chmod +x setup-aws-ec2.sh
./setup-aws-ec2.sh
```

### Step 6: Build Application Locally

```bash
# On your local machine
cd gephub-vpn
mvn clean package -DskipTests
```

### Step 7: Transfer Files to EC2

```bash
# On your local machine
scp -i your-key.pem target/gephub-vpn-0.0.1-SNAPSHOT.jar ubuntu@your-ec2-ip:/opt/gephub-vpn/

# Copy and edit application.properties
scp -i your-key.pem application-aws.properties ubuntu@your-ec2-ip:/opt/gephub-vpn/application.properties

# SSH to EC2 and edit application.properties
ssh -i your-key.pem ubuntu@your-ec2-ip
nano /opt/gephub-vpn/application.properties
# Update RDS endpoint, password, email settings, JWT secret
```

### Step 8: Set Up Systemd Service

```bash
# On EC2 instance
sudo cp gephub-vpn.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gephub-vpn
sudo systemctl start gephub-vpn
sudo systemctl status gephub-vpn
```

### Step 9: Check Logs

```bash
# View service logs
sudo journalctl -u gephub-vpn -f

# View application logs
tail -f /var/log/gephub-vpn/application.log
```

### Step 10: Test API

```bash
# Test from EC2
curl http://localhost:8080/api/actuator/health

# Test from your local machine
curl http://your-ec2-public-ip:8080/api/actuator/health
```

### Step 11: Update Android App

Update your Android app's API base URL to:
```
http://YOUR_EC2_PUBLIC_IP:8080/api
```

Or if using domain:
```
https://yourdomain.com/api
```

---

## Optional: Nginx Reverse Proxy

### Install and Configure Nginx

```bash
# On EC2
sudo apt-get install -y nginx

# Create Nginx config
sudo nano /etc/nginx/sites-available/gephub-vpn
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/gephub-vpn /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## Troubleshooting

### Database Connection Issues
```bash
# Test PostgreSQL connection from EC2
psql -h your-rds-endpoint -U postgres -d gephubvpn
```

### Port Already in Use
```bash
# Check what's using port 8080
sudo lsof -i :8080
# Kill the process
sudo kill -9 <PID>
```

### Service Won't Start
```bash
# Check service status
sudo systemctl status gephub-vpn
# Check logs
sudo journalctl -u gephub-vpn -n 50
```

### Firewall Issues
```bash
# Check firewall status
sudo ufw status
# Allow port
sudo ufw allow 8080/tcp
```

### Memory Issues
```bash
# Check memory usage
free -h
# Increase heap size in gephub-vpn.service
Environment="JAVA_OPTS=-Xms512m -Xmx1024m"
```

---

## Security Checklist

- [ ] Change default database password
- [ ] Use strong JWT secret (min 256 bits)
- [ ] Configure CORS properly (not *)
- [ ] Use HTTPS in production (Let's Encrypt)
- [ ] Restrict RDS access to EC2 security group only
- [ ] Use AWS Secrets Manager for sensitive data
- [ ] Enable CloudWatch logging
- [ ] Set up automated backups for RDS
- [ ] Use IAM roles instead of access keys
- [ ] Regular security updates

---

## Cost Estimation (AWS Free Tier)

- EC2 t2.micro: Free for 12 months (750 hours/month)
- RDS db.t3.micro: Free for 12 months (750 hours/month)
- Data Transfer: First 100 GB free
- **Total: ~$0/month for first year**

After free tier:
- EC2 t2.micro: ~$8-10/month
- RDS db.t3.micro: ~$15/month
- **Total: ~$25/month**


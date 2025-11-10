#!/bin/bash
# deploy-to-aws.sh
# Script to prepare and deploy backend to AWS EC2

echo "========================================="
echo "GepHub VPN Backend - AWS Deployment Guide"
echo "========================================="

echo ""
echo "STEP 1: Build the application JAR"
echo "-----------------------------------"
echo "cd gephub-vpn"
echo "mvn clean package -DskipTests"
echo ""

echo "STEP 2: Create AWS EC2 Instance"
echo "-----------------------------------"
echo "1. Go to AWS Console -> EC2"
echo "2. Launch Instance with:"
echo "   - Ubuntu Server 22.04 LTS"
echo "   - t2.micro or t3.small (free tier eligible)"
echo "   - Security Group: Allow ports 22, 8080, 80, 443"
echo "   - Key Pair: Create/download .pem file"
echo ""

echo "STEP 3: Set up RDS PostgreSQL Database"
echo "-----------------------------------"
echo "1. Go to AWS Console -> RDS"
echo "2. Create Database:"
echo "   - Engine: PostgreSQL"
echo "   - Version: 15.x"
echo "   - Template: Free tier"
echo "   - DB Instance: db.t3.micro"
echo "   - Storage: 20 GB"
echo "   - Master username: postgres"
echo "   - Master password: [strong password]"
echo "   - VPC: Same as EC2 instance"
echo "   - Public access: Yes (for testing)"
echo "   - Security Group: Allow PostgreSQL (5432) from EC2 security group"
echo ""

echo "STEP 4: Connect to EC2 and Set Up"
echo "-----------------------------------"
echo "ssh -i your-key.pem ubuntu@your-ec2-ip"
echo ""
echo "Then run setup-aws-ec2.sh script"
echo ""

echo "STEP 5: Transfer Files"
echo "-----------------------------------"
echo "scp -i your-key.pem target/gephub-vpn-0.0.1-SNAPSHOT.jar ubuntu@your-ec2-ip:~/"
echo "scp -i your-key.pem application-aws.properties ubuntu@your-ec2-ip:~/application.properties"
echo ""

echo "STEP 6: Run Application"
echo "-----------------------------------"
echo "java -jar gephub-vpn-0.0.1-SNAPSHOT.jar --spring.config.location=application.properties"
echo ""

echo "========================================="
echo "For Production: Use systemd service"
echo "See: gephub-vpn.service file"
echo "========================================="


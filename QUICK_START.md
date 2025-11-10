# Quick Start Guide

## For Ubuntu VM Testing

1. **Copy files to VM:**
   ```bash
   scp -r gephub-vpn/ user@vm-ip:~/
   ```

2. **SSH into VM:**
   ```bash
   ssh user@vm-ip
   ```

3. **Run setup:**
   ```bash
   cd gephub-vpn
   chmod +x setup-ubuntu-vm.sh
   ./setup-ubuntu-vm.sh
   ```

4. **Configure:**
   ```bash
   cp application-vm.properties src/main/resources/application.properties
   nano src/main/resources/application.properties
   # Update email settings
   ```

5. **Build and run:**
   ```bash
   mvn clean package -DskipTests
   java -jar target/gephub-vpn-0.0.1-SNAPSHOT.jar
   ```

6. **Get VM IP:**
   ```bash
   hostname -I
   ```

7. **Test:**
   ```bash
   curl http://VM_IP:8080/api/actuator/health
   ```

## For AWS Deployment

1. **Create RDS database** (see DEPLOYMENT.md)

2. **Create EC2 instance** (see DEPLOYMENT.md)

3. **Build JAR locally:**
   ```bash
   cd gephub-vpn
   mvn clean package -DskipTests
   ```

4. **Transfer to EC2:**
   ```bash
   scp -i key.pem target/gephub-vpn-0.0.1-SNAPSHOT.jar ubuntu@ec2-ip:/opt/gephub-vpn/
   scp -i key.pem application-aws.properties ubuntu@ec2-ip:/opt/gephub-vpn/application.properties
   scp -i key.pem setup-aws-ec2.sh ubuntu@ec2-ip:~/
   scp -i key.pem gephub-vpn.service ubuntu@ec2-ip:~/
   ```

5. **On EC2:**
   ```bash
   chmod +x setup-aws-ec2.sh
   ./setup-aws-ec2.sh
   sudo cp gephub-vpn.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable gephub-vpn
   sudo systemctl start gephub-vpn
   ```

6. **Update Android app API URL:**
   ```
   http://EC2_PUBLIC_IP:8080/api
   ```


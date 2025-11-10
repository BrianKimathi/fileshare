# Testing Checklist

## Local VM Testing

- [ ] VM is running and accessible via SSH
- [ ] Java 17 installed (`java -version`)
- [ ] Maven installed (`mvn -version`)
- [ ] PostgreSQL installed and running (`sudo systemctl status postgresql`)
- [ ] Database created (`psql -U gephubuser -d gephubvpn`)
- [ ] Application.properties configured
- [ ] Email settings configured
- [ ] JWT secret changed
- [ ] Application builds successfully (`mvn clean package`)
- [ ] Application starts without errors
- [ ] Health endpoint works (`curl http://localhost:8080/api/actuator/health`)
- [ ] Registration endpoint works
- [ ] OTP email received
- [ ] OTP verification works
- [ ] Login works and returns JWT token
- [ ] Protected endpoints require authentication
- [ ] Android app can connect to backend

## AWS Deployment Testing

- [ ] RDS database created and accessible
- [ ] EC2 instance created and accessible
- [ ] Security groups configured correctly
- [ ] Application JAR transferred to EC2
- [ ] Application.properties configured with RDS endpoint
- [ ] Systemd service created and enabled
- [ ] Service starts successfully (`sudo systemctl status gephub-vpn`)
- [ ] Application logs show no errors
- [ ] Health endpoint accessible from internet
- [ ] Registration works from Android app
- [ ] Login works from Android app
- [ ] All API endpoints functional

## Security Testing

- [ ] Database password is strong
- [ ] JWT secret is strong and random
- [ ] CORS configured properly
- [ ] Unauthorized access blocked
- [ ] SQL injection protection (using JPA)
- [ ] XSS protection
- [ ] HTTPS configured (for production)


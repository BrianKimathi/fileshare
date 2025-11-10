# GepHub VPN Backend API Documentation

## Base URL
```
http://localhost:8080
```

## Authentication Endpoints

### 1. Register User
**POST** `/api/auth/register`

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful. Please verify your email with the OTP code sent."
}
```

### 2. Login
**POST** `/api/auth/login`

**Request Body:**
```json
{
  "usernameOrEmail": "john_doe",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "planType": "FREE"
}
```

### 3. Verify OTP
**POST** `/api/auth/verify-otp`

**Request Body:**
```json
{
  "email": "john@example.com",
  "otpCode": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Email verified successfully"
}
```

## User Endpoints (Requires Authentication)

### 4. Get Current User
**GET** `/api/users/me`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "dataAllowanceGB": 10.0,
  "dataUsedGB": 0.0,
  "resetDate": "2025-11-08",
  "planType": "FREE",
  "referralCode": "ABC12345"
}
```

## Location Endpoints (Public)

### 5. Get All Locations
**GET** `/api/locations`

**Response:**
```json
[
  {
    "id": 1,
    "name": "US East",
    "countryCode": "US",
    "flagEmoji": "🇺🇸",
    "awsRegion": "us-east-1",
    "isActive": true,
    "isComingSoon": false,
    "loadPercentage": 45
  }
]
```

### 6. Get Active Locations
**GET** `/api/locations/active`

**Response:** Same as above, but only active locations

## Setup Instructions

1. **Database Setup:**
   - Create PostgreSQL database: `gephubvpn`
   - Update `application.properties` with your database credentials

2. **Email Configuration:**
   - Update email settings in `application.properties`
   - For Gmail, use App Password (not regular password)

3. **JWT Secret:**
   - Change `jwt.secret` in `application.properties` to a secure random string

4. **Run the Application:**
   ```bash
   cd gephub-vpn
   ./mvnw spring-boot:run
   ```

5. **Test Endpoints:**
   - Use Postman or curl to test the API endpoints
   - Register a user first, then verify OTP, then login to get JWT token


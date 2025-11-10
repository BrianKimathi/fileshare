# GepHub VPN Backend

Spring Boot backend for GepHub VPN Android application.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [API Documentation](#api-documentation)
- [Deployment](#deployment)

## ✨ Features

- ✅ User Registration (username, email, password)
- ✅ Email Verification with OTP
- ✅ JWT Authentication
- ✅ User Management
- ✅ Location Management
- ✅ Connection Logging
- ✅ User Settings Sync
- ✅ Favorite Locations
- ✅ Role-Based Access Control

## 🛠 Tech Stack

- Spring Boot 3.5.7
- Java 17
- PostgreSQL
- Spring Security + JWT
- Maven

## 🚀 Quick Start

See [QUICK_START.md](QUICK_START.md) for detailed instructions.

## 📚 Documentation

- [API Documentation](API_DOCUMENTATION.md)
- [Deployment Guide](DEPLOYMENT.md)
- [Network Config](NETWORK_CONFIG.md)
- [Testing Checklist](TESTING_CHECKLIST.md)

## 🌐 API Endpoints

- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login
- `POST /api/auth/verify-otp` - Verify OTP
- `GET /api/users/me` - Get current user
- `GET /api/locations` - Get locations


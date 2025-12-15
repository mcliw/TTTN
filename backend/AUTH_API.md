# Authentication API Documentation

## Overview
Complete authentication system with JWT tokens, password management, user profiles, and permission checks.

## Endpoints

### 1. Registration
**POST** `/api/v1/auth/register`

Register a new user account.

**Request:**
```json
{
  "username": "sinhvien_moi",
  "password": "Password123!",
  "email": "sv_moi@thanglong.edu.vn"
}
```

**Response (Success 200):**
```json
{
  "data": {
    "user_id": 1,
    "username": "sinhvien_moi",
    "email": "sv_moi@thanglong.edu.vn"
  },
  "message": "Success",
  "error_code": null
}
```

---

### 2. Login
**POST** `/api/v1/auth/login`

Authenticate user and retrieve tokens.

**Request:**
```json
{
  "username": "sinhvien_moi",
  "password": "Password123!"
}
```

**Or with email:**
```json
{
  "email": "sv_moi@thanglong.edu.vn",
  "password": "Password123!"
}
```

**Response (Success 200):**
```json
{
  "data": {
    "user_id": 1,
    "username": "sinhvien_moi",
    "email": "sv_moi@thanglong.edu.vn",
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "bearer"
  },
  "message": "Success",
  "error_code": null
}
```

---

### 3. Refresh Token
**POST** `/api/v1/auth/refresh-token`

Get a new access token using refresh token.

**Request:**
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Success 200):**
```json
{
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "bearer"
  },
  "message": "Success",
  "error_code": null
}
```

---

### 4. Get User Profile
**GET** `/api/v1/auth/profile`

Get current authenticated user's profile (requires JWT token).

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (Success 200):**
```json
{
  "data": {
    "user_id": 1,
    "username": "sinhvien_moi",
    "email": "sv_moi@thanglong.edu.vn",
    "status": "ACTIVE",
    "created_at": "2025-12-16T04:29:57",
    "updated_at": "2025-12-16T04:29:57",
    "profile": {
      "profile_id": 1,
      "user_id": 1,
      "full_name": "Sinh Viên Mới",
      "bio": "Bio here",
      "avatar_url": "/uploads/avatar_1.png"
    }
  },
  "message": "Success",
  "error_code": null
}
```

---

### 5. Get User Profile by ID
**GET** `/api/v1/auth/profile/{user_id}`

Get any user's profile information.

**Response (Success 200):** Same as Get User Profile

---

### 6. Get Users List (Admin)
**GET** `/api/v1/auth/users`

Get list of all users (admin only, requires JWT token).

**Parameters:**
- `limit` (optional, default 100): Number of users to return
- `offset` (optional, default 0): Pagination offset

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (Success 200):**
```json
{
  "data": [
    {
      "user_id": 1,
      "username": "sinhvien_moi",
      "email": "sv_moi@thanglong.edu.vn",
      "status": "ACTIVE",
      "created_at": "2025-12-16T04:29:57"
    },
    {
      "user_id": 2,
      "username": "sinhvien_2",
      "email": "sv_2@thanglong.edu.vn",
      "status": "ACTIVE",
      "created_at": "2025-12-16T04:30:00"
    }
  ],
  "message": "Success",
  "error_code": null
}
```

---

### 7. Update User Profile
**PUT** `/api/v1/auth/profile/{user_id}`

Update user profile information.

**Request (Form Data):**
```
full_name: "Sinh Viên Mới"
bio: "My bio"
avatar: <file>
```

**Response (Success 200):**
```json
{
  "data": {
    "profile_id": 1,
    "user_id": 1,
    "full_name": "Sinh Viên Mới",
    "bio": "My bio",
    "avatar_url": "/uploads/avatar_1.png"
  },
  "message": "Success",
  "error_code": null
}
```

---

### 8. Change Password
**POST** `/api/v1/auth/change-password`

Change user password (requires JWT token).

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request:**
```json
{
  "old_password": "Password123!",
  "new_password": "NewPassword456!",
  "confirm_password": "NewPassword456!"
}
```

**Response (Success 200):**
```json
{
  "data": {
    "user_id": 1
  },
  "message": "Password changed successfully",
  "error_code": null
}
```

---

### 9. Forgot Password
**POST** `/api/v1/auth/forgot-password`

Request password reset email.

**Request:**
```json
{
  "email": "sv_moi@thanglong.edu.vn"
}
```

**Response (Success 200):**
```json
{
  "data": {},
  "message": "If email exists, password reset link has been sent",
  "error_code": null
}
```

---

### 10. Reset Password
**POST** `/api/v1/auth/reset-password`

Reset password using token from email.

**Request:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "new_password": "NewPassword456!",
  "confirm_password": "NewPassword456!"
}
```

**Response (Success 200):**
```json
{
  "data": {},
  "message": "Password reset successfully",
  "error_code": null
}
```

---

### 11. Check Permission
**POST** `/api/v1/auth/check-permission`

Check if user has permission for resource and action (requires JWT token).

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request:**
```json
{
  "resource": "chat",
  "action": "create"
}
```

**Response (Success 200):**
```json
{
  "data": {
    "allowed": true,
    "resource": "chat",
    "action": "create",
    "reason": null
  },
  "message": "Success",
  "error_code": null
}
```

---

## Security Features

### JWT Token Types
1. **Access Token** (expires in 60 minutes by default)
   - Used for API authentication
   - Type: "access"

2. **Refresh Token** (expires in 7 days by default)
   - Used to obtain new access token
   - Type: "refresh"

3. **Password Reset Token** (expires in 30 minutes by default)
   - Used for password reset flow
   - Type: "password_reset"

### Authentication
All endpoints requiring authentication use Bearer token in Authorization header:
```
Authorization: Bearer <access_token>
```

### Role-Based Access Control
- Admin users have `role_id = 1`
- Admin users can access user list endpoint
- Regular users can access their own profile

### Password Requirements
- Minimum 6 characters
- New and confirm password must match

---

## Environment Variables

```env
# JWT Configuration
JWT_SECRET=your-secret-key-here
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
REFRESH_TOKEN_EXPIRE_DAYS=7
PASSWORD_RESET_TOKEN_EXPIRE_MINUTES=30

# Email Configuration (for password reset)
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
EMAIL_FROM=noreply@thanglong.edu.vn
```

---

## Error Responses

### 401 Unauthorized
```json
{
  "detail": "Invalid credentials"
}
```

### 403 Forbidden
```json
{
  "detail": "Admin access required"
}
```

### 404 Not Found
```json
{
  "detail": "User not found"
}
```

### 422 Validation Error
```json
{
  "data": null,
  "message": "Validation Error",
  "error_code": "validation_error",
  "errors": [
    {
      "type": "value_error",
      "loc": ["body", "new_password"],
      "msg": "new_password and confirm_password must match"
    }
  ]
}
```

---

## Usage Examples

### 1. Complete Login Flow
```bash
# Register
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "password": "Pass123!",
    "email": "user@example.com"
  }'

# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "password": "Pass123!"
  }'

# Get Profile (using access_token from login response)
curl -X GET http://localhost:8000/api/v1/auth/profile \
  -H "Authorization: Bearer <access_token>"

# Refresh Token
curl -X POST http://localhost:8000/api/v1/auth/refresh-token \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "<refresh_token>"
  }'
```

### 2. Password Reset Flow
```bash
# Request password reset
curl -X POST http://localhost:8000/api/v1/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com"
  }'

# Reset password (token from email)
curl -X POST http://localhost:8000/api/v1/auth/reset-password \
  -H "Content-Type: application/json" \
  -d '{
    "token": "<reset_token_from_email>",
    "new_password": "NewPass456!",
    "confirm_password": "NewPass456!"
  }'
```

### 3. Admin Operations
```bash
# Get users list (requires admin token)
curl -X GET "http://localhost:8000/api/v1/auth/users?limit=10&offset=0" \
  -H "Authorization: Bearer <admin_access_token>"

# Change password
curl -X POST http://localhost:8000/api/v1/auth/change-password \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "old_password": "OldPass123!",
    "new_password": "NewPass456!",
    "confirm_password": "NewPass456!"
  }'
```

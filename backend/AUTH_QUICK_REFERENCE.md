# Authentication Quick Reference

## 11 Authentication Functions Implemented

### 1. **Registration** ✅
- **Endpoint**: `POST /api/v1/auth/register`
- **Input**: username, password, email
- **Output**: user_id, username, email
- **Auto-creates**: User profile, default settings

### 2. **Login** ✅
- **Endpoint**: `POST /api/v1/auth/login`
- **Input**: username/email + password
- **Output**: access_token, refresh_token, user_id, username, email
- **Token expiry**: 60 minutes (access), 7 days (refresh)

### 3. **Token Refresh** ✅
- **Endpoint**: `POST /api/v1/auth/refresh-token`
- **Input**: refresh_token
- **Output**: new access_token
- **Use case**: Get new access token without re-login

### 4. **Retrieve User Information** ✅
- **Endpoint**: `GET /api/v1/auth/profile`
- **Auth**: Bearer token required
- **Output**: user_id, username, email, status, profile, timestamps
- **Scope**: Current user's own data

### 5. **Retrieve User List (Admin)** ✅
- **Endpoint**: `GET /api/v1/auth/users`
- **Auth**: Bearer token (admin role required)
- **Params**: limit, offset (pagination)
- **Output**: Array of users with basic info
- **Scope**: Admin only

### 6. **Update User Information** ✅
- **Endpoint**: `PUT /api/v1/auth/profile/{user_id}`
- **Input**: full_name, bio, avatar (file)
- **Output**: Updated profile data
- **Method**: Form data with multipart support

### 7. **Change Password** ✅
- **Endpoint**: `POST /api/v1/auth/change-password`
- **Auth**: Bearer token required
- **Input**: old_password, new_password, confirm_password
- **Output**: user_id
- **Validation**: Old password verified

### 8. **Forgot Password** ✅
- **Endpoint**: `POST /api/v1/auth/forgot-password`
- **Input**: email
- **Output**: Success message
- **Action**: Sends reset email (if configured)

### 9. **Reset Password** ✅
- **Endpoint**: `POST /api/v1/auth/reset-password`
- **Input**: reset_token (from email), new_password, confirm_password
- **Output**: Success message
- **Security**: Token expires in 30 minutes

### 10. **Permission Checking** ✅
- **Endpoint**: `POST /api/v1/auth/check-permission`
- **Auth**: Bearer token required
- **Input**: resource, action
- **Output**: allowed (boolean), reason
- **Current logic**: Checks if user is ACTIVE

### 11. **Role-Based Access Control** ✅
- **Implementation**: Through dependencies
- **Admin role**: role_id = 1
- **User role**: role_id ≠ 1
- **Usage**: Protect endpoints with `get_current_admin_user` dependency

---

## Quick API Reference

| Function | Method | Endpoint | Auth | Role |
|----------|--------|----------|------|------|
| Register | POST | `/auth/register` | ❌ | - |
| Login | POST | `/auth/login` | ❌ | - |
| Refresh | POST | `/auth/refresh-token` | ❌ | - |
| Get Profile | GET | `/auth/profile` | ✅ | User |
| Get User List | GET | `/auth/users` | ✅ | Admin |
| Update Profile | PUT | `/auth/profile/{id}` | ✅ | User |
| Change Password | POST | `/auth/change-password` | ✅ | User |
| Forgot Password | POST | `/auth/forgot-password` | ❌ | - |
| Reset Password | POST | `/auth/reset-password` | ❌ | - |
| Check Permission | POST | `/auth/check-permission` | ✅ | User |

---

## Token Usage in Requests

```bash
# All authenticated endpoints require:
Authorization: Bearer <access_token>

# Example:
curl -X GET http://localhost:8000/api/v1/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## Using Security Dependencies in Code

### Protect endpoint with authentication:
```python
from app.core.security import get_current_user
from app.models import UserAccount

@app.get("/protected")
def protected_endpoint(user: UserAccount = Depends(get_current_user)):
    return {"user_id": user.user_id, "username": user.username}
```

### Protect endpoint with admin role:
```python
from app.core.security import get_current_admin_user

@app.get("/admin-only")
def admin_endpoint(admin: UserAccount = Depends(get_current_admin_user)):
    return {"message": "Admin access granted"}
```

### Protect endpoint with permission check:
```python
from app.core.security import require_permission

@app.post("/chat/create")
def create_chat(
    user: UserAccount = Depends(require_permission("chat", "create"))
):
    return {"message": "Chat created"}
```

---

## Default Configuration

```python
# Token Expiry Times (configurable via .env)
ACCESS_TOKEN_EXPIRE_MINUTES = 60
REFRESH_TOKEN_EXPIRE_DAYS = 7
PASSWORD_RESET_TOKEN_EXPIRE_MINUTES = 30

# JWT Settings
JWT_ALGORITHM = "HS256"
JWT_SECRET = "change-me-in-prod"

# User Status
ACTIVE = "ACTIVE"
INACTIVE = "INACTIVE"

# Admin Role
ADMIN_ROLE_ID = 1
USER_ROLE_ID = 2
```

---

## Common Workflows

### Complete Authentication Flow
```
1. User calls POST /auth/register
   → Account created, profile initialized

2. User calls POST /auth/login
   → Returns access_token + refresh_token

3. User calls GET /auth/profile
   → Header: Authorization: Bearer <access_token>
   → Returns user profile

4. After 60 minutes, access_token expires

5. User calls POST /auth/refresh-token
   → Body: {"refresh_token": "..."}
   → Returns new access_token

6. User calls POST /auth/change-password
   → Header: Authorization: Bearer <new_access_token>
   → Password changed
```

### Password Reset Flow
```
1. User calls POST /auth/forgot-password
   → Email: sv_moi@thanglong.edu.vn
   → System sends email with reset link

2. Email contains reset link:
   → http://localhost:8000/reset-password?token=<jwt_token>

3. User submits new password to POST /auth/reset-password
   → Body: {"token": "<jwt>", "new_password": "...", "confirm_password": "..."}
   → Password reset

4. User calls POST /auth/login with new password
   → Login successful
```

### Admin User List Access
```
1. Admin user calls POST /auth/login
   → Gets access_token

2. Admin calls GET /auth/users?limit=50&offset=0
   → Header: Authorization: Bearer <access_token>
   → Returns array of users

3. If non-admin tries this endpoint
   → Response: 403 Forbidden "Admin access required"
```

---

## Database Models Required

```python
# UserAccount
- user_id (PK)
- username (unique)
- password_hash
- email
- status (ACTIVE/INACTIVE)
- role_id (FK to UserRole)
- created_at, updated_at

# UserProfile
- profile_id (PK)
- user_id (FK)
- full_name
- bio
- avatar_url

# UserRole
- role_id (PK)
- role_name (e.g., "Admin", "User")
- description
```

---

## Email Configuration (Optional)

For password reset emails to work:

```bash
# In .env file:
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=app-specific-password  # Not your regular password
EMAIL_FROM=noreply@thanglong.edu.vn
```

---

## Error Messages by Endpoint

| Scenario | HTTP | Message |
|----------|------|---------|
| User not found | 404 | "User not found" |
| Invalid credentials | 401 | "Invalid credentials" |
| Expired token | 401 | "Invalid or expired token" |
| Incorrect old password | 401 | "Incorrect old password" |
| User not admin | 403 | "Admin access required" |
| User inactive | 403 | "User account is inactive" |
| Username exists | 400 | "Username already exists" |
| Passwords don't match | 422 | "new_password and confirm_password must match" |

---

## Security Best Practices

✅ **Implemented**
- Password hashing with salt
- JWT token expiration
- Separate access/refresh tokens
- Token type validation
- User status checking
- Role-based access control
- Password confirmation

⚠️ **Recommended for Production**
- Change JWT_SECRET to random string
- Use HTTPS only
- Implement rate limiting
- Add token blacklist for logout
- Enable SMTP for emails
- Use environment-specific configs
- Add audit logging
- Implement 2FA

---

## Testing Endpoints

### Using cURL

```bash
# Register
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"Pass123!","email":"user@example.com"}'

# Login
TOKEN=$(curl -s -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"Pass123!"}' | jq -r '.data.access_token')

# Get Profile
curl -X GET http://localhost:8000/api/v1/auth/profile \
  -H "Authorization: Bearer $TOKEN"

# Change Password
curl -X POST http://localhost:8000/api/v1/auth/change-password \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "old_password":"Pass123!",
    "new_password":"NewPass456!",
    "confirm_password":"NewPass456!"
  }'
```

---

## Files Modified/Created

```
app/
├── core/
│   ├── config.py (Updated - added JWT/email config)
│   └── security.py (Updated - added auth dependencies)
├── schemas/
│   └── auth.py (Updated - added 7 new schemas)
├── services/
│   └── auth_service.py (Updated - added 10 new methods)
└── api/
    └── v1/
        └── endpoints/
            └── auth.py (Updated - added 9 new endpoints)

Documentation:
├── AUTH_API.md (New - full API documentation)
├── AUTHENTICATION_IMPLEMENTATION.md (New - implementation details)
└── AUTH_QUICK_REFERENCE.md (This file)
```

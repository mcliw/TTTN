# Complete API Endpoint Reference

## Base URL
```
http://localhost:8000/api
```

## Health Check
```
GET /health
Response: {"status": "ok", "database_ready": true}
```

---

## Authentication Module (v1/auth)

### Register User
```
POST /v1/auth/register
Content-Type: application/json

Request:
{
  "username": "student001",
  "password": "secure_password_123",
  "email": "student@tlu.edu.vn"
}

Response (201):
{
  "data": {
    "user_id": 123,
    "username": "student001",
    "email": "student@tlu.edu.vn"
  },
  "message": "Success",
  "error_code": null
}

Transaction: 
  ✓ Creates UserAccount + UserProfile + 5 default SystemSettings
  ✓ All succeed or all rollback (atomic)
```

### Login User (JWT)
```
POST /v1/auth/login
Content-Type: application/json

Request:
{
  "username": "student001",
  "password": "secure_password_123"
}

OR

{
  "email": "student@tlu.edu.vn",
  "password": "secure_password_123"
}

Response (200):
{
  "data": {
    "user_id": 123,
    "username": "student001",
    "email": "student@tlu.edu.vn",
    "access_token": "eyJhbGciOiJIUzI1NiIs..."
  },
  "message": "Success",
  "error_code": null
}
```

### Update User Profile
```
PUT /v1/auth/profile/{user_id}
Content-Type: multipart/form-data

Parameters:
  - full_name: (optional) string
  - bio: (optional) string
  - avatar: (optional) file

Response (200):
{
  "data": {
    "profile_id": 456,
    "user_id": 123,
    "full_name": "Nguyễn Văn A",
    "bio": "Computer Science Student",
    "avatar_url": "uploads/avatars/avatar-abc123.jpg"
  },
  "message": "Success",
  "error_code": null
}

Transaction:
  ✓ File uploaded → DB updated
  ✓ If DB fails, file automatically deleted (compensating transaction)
```

---

## Chat Module (v1/chat)

### Send Message
```
POST /v1/chat/message
Content-Type: application/json

Request:
{
  "session_id": 789,
  "user_id": 123,
  "message_content": "What is my GPA?"
}

Response (200):
{
  "data": {
    "query": "What is my GPA?",
    "history": [
      {
        "sender": "user",
        "content": "Hello",
        "status": "DONE"
      },
      {
        "sender": "bot",
        "content": "Hi there!",
        "status": "DONE"
      },
      {
        "sender": "user",
        "content": "What is my GPA?",
        "status": "PROCESSING"
      }
    ]
  },
  "message": "Success",
  "error_code": null
}

Background Process:
  1. Message saved as PENDING
  2. Payload returned immediately
  3. Background thread triggers N8N webhook
  4. Bot response saved automatically
  5. Status updated to PROCESSING/DONE
```

### Get Chat History
```
GET /v1/chat/{session_id}/history?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "message_id": 101,
        "sender": "user",
        "content": "What courses am I taking?",
        "status": "DONE",
        "created_at": "2025-12-15T10:30:00"
      },
      {
        "message_id": 102,
        "sender": "bot",
        "content": "You are enrolled in...",
        "status": "DONE",
        "created_at": "2025-12-15T10:31:00"
      }
    ],
    "total": 150,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}
```

---

## Academic Module (v1/academic)

### Get Student Grades
```
GET /v1/academic/grades/{student_id}

Response (200):
{
  "data": [
    {
      "subject": "Data Structures",
      "grade": 8.5,
      "credits": 3
    },
    {
      "subject": "Algorithms",
      "grade": 9.0,
      "credits": 4
    }
  ],
  "message": "Success",
  "error_code": null
}

Note: Currently returns mock data. In production, integrate with real academic database.
```

### Get Student Schedule
```
GET /v1/academic/schedule/{student_id}

Response (200):
{
  "data": [
    {
      "subject": "Data Structures",
      "time": "Monday 09:00-11:00",
      "room": "Room 101",
      "lecturer": "Prof. A"
    }
  ],
  "message": "Success",
  "error_code": null
}
```

### List All Subjects
```
GET /v1/academic/subjects?limit=50

Response (200):
{
  "data": [
    {
      "data_id": 1,
      "intent_id": 10,
      "input_text": "Tell me about data structures",
      "label": "data_structures"
    }
  ],
  "message": "Success",
  "error_code": null
}
```

### Search Subjects
```
GET /v1/academic/subjects/search?query=database

Response (200):
{
  "data": [
    {
      "data_id": 5,
      "intent_id": 15,
      "input_text": "Database management systems",
      "label": "database_design"
    }
  ],
  "message": "Success",
  "error_code": null
}
```

### Get User Notifications
```
GET /v1/academic/notifications/{user_id}?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "notification_id": 1,
        "title": "New support request from student 456",
        "message": "Student submitted a request",
        "status": "UNREAD",
        "created_at": "2025-12-15T14:00:00"
      }
    ],
    "total": 5,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}
```

---

## Support Module (v1/support)

### Submit Support Request
```
POST /v1/support/request
Content-Type: application/json

Request:
{
  "user_id": 123,
  "title": "Grade Appeal",
  "description": "I believe my grade should be higher",
  "category": "academic"
}

Response (201):
{
  "data": {
    "feedback_id": 999,
    "user_id": 123,
    "title": "Grade Appeal",
    "description": "I believe my grade should be higher",
    "status": "OPEN",
    "created_at": "2025-12-15T15:00:00"
  },
  "message": "Success",
  "error_code": null
}

Trigger:
  ✓ Creates SystemFeedback record
  ✓ Notifies advisor(s) via SystemNotification
```

### Get Student's Support Requests
```
GET /v1/support/requests/{student_id}?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "feedback_id": 999,
        "user_id": 123,
        "title": "Grade Appeal",
        "description": "I believe my grade should be higher",
        "status": "OPEN",
        "created_at": "2025-12-15T15:00:00"
      }
    ],
    "total": 3,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}
```

### Get Students Assigned to Advisor
```
GET /v1/support/advisor/{advisor_id}/students?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "user_id": 123,
        "username": "student001",
        "email": "student@tlu.edu.vn",
        "full_name": "Nguyễn Văn A",
        "phone": "+84912345678",
        "department_id": 5,
        "avatar_url": "uploads/avatars/..."
      }
    ],
    "total": 45,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}

Logic:
  ✓ Fetches students from same department as advisor
  ✓ Eager loads profiles to prevent N+1 queries
```

### Get Student Profile (for Advisor)
```
GET /v1/support/student/{student_id}/profile?advisor_id={advisor_id}

Response (200):
{
  "data": {
    "user_id": 123,
    "username": "student001",
    "email": "student@tlu.edu.vn",
    "full_name": "Nguyễn Văn A",
    "phone": "+84912345678",
    "department_id": 5,
    "avatar_url": "uploads/avatars/..."
  },
  "message": "Success",
  "error_code": null
}
```

### Reply to Support Request
```
POST /v1/support/reply?advisor_id={advisor_id}
Content-Type: application/json

Request:
{
  "feedback_id": 999,
  "reply_message": "Your grade has been reviewed. The decision stands."
}

Response (200):
{
  "data": {
    "request_id": 999,
    "replied": true
  },
  "message": "Reply sent successfully",
  "error_code": null
}

Trigger:
  ✓ Updates request status
  ✓ Notifies student via SystemNotification
```

---

## Admin Module (v1/admin)

### Get Dashboard Statistics
```
GET /v1/admin/dashboard/stats

Response (200):
{
  "data": {
    "total_users": 1250,
    "active_sessions_today": 342,
    "error_count": 12,
    "total_support_requests": 87
  },
  "message": "Success",
  "error_code": null
}

Performance:
  ✓ Single count query per metric
  ✓ Efficient aggregation in DB
```

### List All Users
```
GET /v1/admin/users?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "user_id": 123,
        "username": "student001",
        "email": "student@tlu.edu.vn",
        "status": "ACTIVE",
        "created_at": "2025-12-01T10:00:00"
      }
    ],
    "total": 1250,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}
```

### Ban User
```
POST /v1/admin/users/{user_id}/ban

Response (200):
{
  "data": {
    "user_id": 123,
    "status": "BANNED"
  },
  "message": "User banned successfully",
  "error_code": null
}
```

### Unban User
```
POST /v1/admin/users/{user_id}/unban

Response (200):
{
  "data": {
    "user_id": 123,
    "status": "ACTIVE"
  },
  "message": "User unbanned successfully",
  "error_code": null
}
```

### Assign Role to User
```
POST /v1/admin/users/{user_id}/assign-role?role_id={role_id}

Response (200):
{
  "data": {
    "user_id": 123,
    "role_id": 2
  },
  "message": "Role assigned successfully",
  "error_code": null
}

Roles:
  1 = Student
  2 = Advisor/CVHT
  3 = Admin
```

### List Workflow Configurations
```
GET /v1/admin/workflows?page=1&size=20

Response (200):
{
  "data": {
    "items": [
      {
        "workflow_id": 5,
        "workflow_name": "Grade Processing",
        "description": "Process grade updates",
        "endpoint_url": "https://n8n.example.com/webhook/grade-process",
        "status": "ACTIVE",
        "created_at": "2025-12-10T09:00:00"
      }
    ],
    "total": 8,
    "page": 1,
    "size": 20
  },
  "message": "Success",
  "error_code": null
}
```

### Create Workflow
```
POST /v1/admin/workflows?admin_id={admin_id}
Content-Type: application/json

Request:
{
  "workflow_name": "Grade Processing",
  "description": "Process grade updates",
  "endpoint_url": "https://n8n.example.com/webhook/grade-process",
  "auth_token": "token123",
  "status": "ACTIVE"
}

Response (201):
{
  "data": {
    "workflow_id": 5,
    "workflow_name": "Grade Processing",
    "status": "ACTIVE"
  },
  "message": "Workflow created successfully",
  "error_code": null
}
```

### Update Workflow
```
PUT /v1/admin/workflows/{workflow_id}
Content-Type: application/json

Request: (same as create)

Response (200):
{
  "data": {
    "workflow_id": 5,
    "workflow_name": "Grade Processing",
    "status": "ACTIVE"
  },
  "message": "Workflow updated successfully",
  "error_code": null
}
```

### Delete Workflow
```
DELETE /v1/admin/workflows/{workflow_id}

Response (200):
{
  "data": {
    "workflow_id": 5,
    "deleted": true
  },
  "message": "Workflow deleted successfully",
  "error_code": null
}
```

### Update System Setting
```
PUT /v1/admin/settings
Content-Type: application/json

Request:
{
  "key_name": "system:maintenance_mode",
  "value": "false",
  "description": "Enable/disable maintenance mode"
}

Response (200):
{
  "data": {
    "setting_id": 42,
    "key_name": "system:maintenance_mode",
    "value": "false"
  },
  "message": "Setting updated successfully",
  "error_code": null
}
```

---

## Error Responses

### Validation Error (400)
```json
{
  "data": null,
  "message": "Validation Error",
  "error_code": "validation_error",
  "errors": [
    {
      "loc": ["body", "username"],
      "msg": "ensure this value has at least 3 characters",
      "type": "value_error.string.min_length"
    }
  ]
}
```

### Unauthorized (401)
```json
{
  "data": null,
  "message": "Invalid credentials",
  "error_code": "http_error"
}
```

### Not Found (404)
```json
{
  "data": null,
  "message": "User not found",
  "error_code": "http_error"
}
```

### Internal Server Error (500)
```json
{
  "data": null,
  "message": "Internal Server Error",
  "error_code": "internal_error"
}
```

---

## Common Query Parameters

### Pagination
```
?page=1        # Page number (default: 1)
&size=20       # Items per page (default: 20, max: 100)
```

### Filtering
```
?query=database     # Search term
```

---

## Best Practices for API Consumers

1. **Check error_code:** Always check if `error_code` is null before processing data
2. **Pagination:** Use page/size for large result sets
3. **Error Handling:** Implement retry logic for 5xx errors
4. **Rate Limiting:** Implement exponential backoff
5. **Caching:** Cache GET responses appropriately
6. **Logging:** Log all API interactions for debugging

---

**Documentation Version:** 1.0
**Last Updated:** December 15, 2025

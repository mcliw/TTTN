# AI Agent Chatbot System for Students & Academic Advisors - Backend Implementation

## Project Overview

This is a production-grade FastAPI backend for an AI-powered chatbot system serving students and academic advisors at TLU (Tôn Đức Thắng University). The implementation follows **Clean Architecture** principles with strict separation of concerns across API → Service → Repository → Model layers.

## Architecture Overview

```
app/
├── api/v1/endpoints/           # API Routers (HTTP layer)
│   ├── auth.py                # Authentication & User Management
│   ├── chat.py                # Chatbot Core
│   ├── academic.py            # Student Academic Features
│   ├── support.py             # Advisor/Support System
│   └── admin.py               # Admin Dashboard & Management
├── core/
│   ├── config.py              # Configuration Management
│   ├── database.py            # DB Connection & Session Management
│   ├── bootstrap.py           # System Initialization
│   └── settings.py            # App Settings
├── models/                     # SQLAlchemy ORM Models
├── schemas/                    # Pydantic Request/Response Models
├── services/                   # Business Logic Layer
├── repositories/               # Data Access Layer (Repository Pattern)
├── ai/                         # AI/LLM Integration
├── n8n/                        # N8N Workflow Integration
└── utils/                      # Utilities (File handling, etc.)
```

## Key Features & Use Cases

### Module 1: Authentication & User Management (UC1-UC6, UC19)
**File Structure:**
- `app/api/v1/endpoints/auth.py` - Register, Login, Profile management
- `app/services/auth_service.py` - Auth business logic
- `app/repositories/user_repo.py` - User CRUD operations

**Features:**
- User registration with atomic transaction (user_account + user_profile + default settings)
- JWT-based authentication
- Profile updates with avatar upload and compensating file deletion on failure
- User management (Ban/Assign roles)

### Module 2: Chatbot Core (UC7, UC8, UC13, UC25)
**File Structure:**
- `app/api/v1/endpoints/chat.py` - Message posting & history
- `app/services/chat_service.py` - Chat processing logic
- `app/ai/intent_classifier.py` - Intent detection (mock)
- `app/n8n/webhook_service.py` - External workflow triggers

**Features:**
- User message persistence (PENDING → PROCESSING)
- Background N8N webhook triggering
- Chat history with pagination
- Intent classification (mock implementation)

### Module 3: Academic & Notifications (UC9-UC11, UC17, UC20)
**File Structure:**
- `app/api/v1/endpoints/academic.py` - Grade, schedule, subject endpoints
- `app/services/academic_service.py` - Academic logic
- `app/repositories/academic_repo.py` - Academic data access

**Features:**
- Grade lookup (mock data)
- Schedule lookup (mock data)
- Subject search & listing
- Notification management with pagination

### Module 4: Support System (UC12, UC14-UC16)
**File Structure:**
- `app/api/v1/endpoints/support.py` - Support request endpoints
- `app/services/support_service.py` - Support logic
- `app/repositories/support_repo.py` - Support data access

**Features:**
- Student support request submission
- Advisor assignment to students (by department)
- Student profile viewing for advisors
- Request reply system with notifications

### Module 5: Admin Dashboard (UC19, UC21-UC27)
**File Structure:**
- `app/api/v1/endpoints/admin.py` - Admin endpoints
- `app/services/admin_service.py` - Admin business logic
- `app/repositories/admin_repo.py` - Admin data access

**Features:**
- Dashboard statistics (user count, active sessions, errors)
- User management (list, ban, assign roles)
- Workflow configuration CRUD
- System settings management

## Technical Standards & Patterns

### 1. Transaction Management
All write operations use SQLAlchemy's context manager for atomicity:

```python
with db.begin():
    # Multiple operations guarantee atomicity
    user = UserAccount(...)
    db.add(user)
    db.flush()
    
    # If any operation fails, all changes rollback
    settings = SystemSetting(...)
    db.add(settings)
```

### 2. Data Validation
- **Request validation:** Pydantic schemas with Field constraints
- **Type checking:** All inputs validated at API layer before service processing
- **Error responses:** Standardized JSON structure

```json
{
  "data": {...},
  "message": "Success/Error",
  "error_code": null
}
```

### 3. Performance Optimization
- **Eager loading:** Uses `selectinload()` to prevent N+1 queries
- **Pagination:** All list endpoints support page/size parameters
- **Batch operations:** Bulk inserts for default settings creation

### 4. Error Handling
- **Defensive checks:** `if entity is None` before operations
- **Custom exceptions:** HTTPException with descriptive messages
- **Logging:** All major actions logged with context (user_id, resource_id, etc.)

### 5. File Management
- **Upload handling:** FileService for avatar uploads
- **Rollback compensation:** If DB fails after file upload, file is deleted automatically
- **Path safety:** Files stored in configured `UPLOAD_DIR`

### 6. Database Relationships
```python
# Eager loading example
stmt = select(UserAccount).options(
    selectinload(UserAccount.profile),
    selectinload(UserAccount.sessions)
)

# Prevents lazy loading and N+1 queries
```

## API Endpoints Reference

### Authentication (v1/auth)
```
POST   /v1/auth/register              - Register new user
POST   /v1/auth/login                 - Login with JWT token
PUT    /v1/auth/profile/{user_id}     - Update profile (with avatar upload)
```

### Chat (v1/chat)
```
POST   /v1/chat/message               - Send/process message
GET    /v1/chat/{session_id}/history  - Fetch chat history (paginated)
```

### Academic (v1/academic)
```
GET    /v1/academic/grades/{student_id}           - Get student grades
GET    /v1/academic/schedule/{student_id}         - Get student schedule
GET    /v1/academic/subjects                      - List all subjects
GET    /v1/academic/subjects/search?query=...     - Search subjects
GET    /v1/academic/notifications/{user_id}       - Get notifications
```

### Support (v1/support)
```
POST   /v1/support/request                        - Submit support request
GET    /v1/support/requests/{student_id}          - Get student requests
GET    /v1/support/advisor/{advisor_id}/students  - Get assigned students (UC14)
GET    /v1/support/student/{student_id}/profile   - Get student profile (UC15)
POST   /v1/support/reply                          - Reply to request (UC16)
```

### Admin (v1/admin)
```
GET    /v1/admin/dashboard/stats                   - Dashboard statistics
GET    /v1/admin/users                            - List all users (paginated)
POST   /v1/admin/users/{user_id}/ban              - Ban user
POST   /v1/admin/users/{user_id}/unban            - Unban user
POST   /v1/admin/users/{user_id}/assign-role      - Assign role
GET    /v1/admin/workflows                        - List workflows
POST   /v1/admin/workflows                        - Create workflow
PUT    /v1/admin/workflows/{workflow_id}          - Update workflow
DELETE /v1/admin/workflows/{workflow_id}          - Delete workflow
PUT    /v1/admin/settings                         - Update system setting
```

## Database Models Used

### Core Models
- **UserAccount** - User credentials & metadata
- **UserProfile** - Extended user info (name, avatar, department)
- **UserRole** - Role definitions

### Chat Models
- **ChatSession** - Conversation sessions
- **ChatMessage** - Individual messages
- **ChatIntent** - Intent classification
- **ChatEntity** - Entity extraction

### Academic Models
- **AITrainingDataset** - Subject/training data
- **SystemNotification** - User notifications

### Support Models
- **SystemFeedback** - Support requests/feedback
- **CommonDepartment** - Department info

### System Models
- **SystemSetting** - App configuration
- **SystemErrorLog** - Error tracking
- **WorkflowConfig** - N8N workflow definitions
- **WorkflowExecutionLog** - Workflow execution history

## Configuration

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql+psycopg://user:password@localhost:5432/tlu_db

# Security
JWT_SECRET=your-secret-key
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

# Files
UPLOAD_DIR=uploads

# AI/LLM
OPENAI_API_KEY=your-api-key
CHROMA_PERSIST_DIR=./chroma_data

# Workflows
N8N_URL=http://localhost:5678
N8N_API_KEY=your-n8n-key
```

## Running the Application

### Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run server (with auto-reload)
python app/main.py

# Or with uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Production
```bash
# Docker
docker build -t chatbot-backend .
docker run -p 8000:8000 -e DATABASE_URL=... chatbot-backend
```

## Code Quality & Best Practices

✅ **Clean Architecture:** Strict layer separation (API → Service → Repository → Model)
✅ **Transaction Safety:** All write operations use `with db.begin():`
✅ **N+1 Prevention:** Eager loading with selectinload/joinedload
✅ **Validation:** Comprehensive Pydantic schemas
✅ **Error Handling:** Standardized responses and logging
✅ **File Safety:** Compensating transactions for file operations
✅ **Async Ready:** Designed for SQLAlchemy async patterns (future)
✅ **Documentation:** Logging at all critical points

## Testing

Each module includes comprehensive logging and defensive checks. To add unit tests:

```python
# tests/services/test_auth_service.py
def test_register_user(db_session):
    service = AuthService(db_session)
    result = service.register(db_session, RegisterRequest(...))
    assert result["data"]["user_id"] > 0
    assert result["error_code"] is None
```

## Future Enhancements

1. **Async SQLAlchemy:** Migrate to AsyncSession for true async/await support
2. **Real AI Integration:** Replace intent classifier mocks with real LLM
3. **Email Notifications:** Send actual emails instead of DB records
4. **Rate Limiting:** Add rate limit middleware
5. **API Documentation:** Auto-generated OpenAPI/Swagger docs
6. **Caching:** Redis layer for frequently accessed data
7. **Search:** Full-text search for subjects/notifications
8. **Export:** CSV/Excel export for reports

## Support & Contributing

For issues or contributions, please follow the existing patterns:
1. Create schema in `app/schemas/`
2. Create repository in `app/repositories/`
3. Create service in `app/services/`
4. Create endpoint in `app/api/v1/endpoints/`
5. Add logging and error handling
6. Test all transactions

---

**Last Updated:** December 2025
**Framework:** FastAPI + SQLAlchemy
**Python Version:** 3.8+

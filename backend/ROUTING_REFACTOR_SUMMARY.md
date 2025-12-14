# API Routing Refactoring - Single Source of Truth

## Overview
Successfully refactored the entire routing system to comply with the "Single Source of Truth" principle. All URL paths are now centralized in `app/core/api_paths.py`.

## Files Created

### `app/core/api_paths.py`
New centralized configuration file containing the `APIPaths` class with hierarchical path management:

```python
class APIPaths:
    PREFIX_V1 = "/api/v1"
    
    class Auth:
        PREFIX = "/auth"
        REGISTER = "/register"
        LOGIN = "/login"
        PROFILE = "/profile"
        PROFILE_BY_ID = "/profile/{user_id}"
    
    class Chat:
        PREFIX = "/chat"
        SEND_MESSAGE = "/message"
        HISTORY = "/{session_id}/history"
    
    class Academic:
        PREFIX = "/academic"
        STUDENT_GRADES = "/grades/{student_id}"
        # ... (more paths)
    
    class Support:
        PREFIX = "/support"
        SUBMIT_REQUEST = "/request"
        # ... (more paths)
    
    class Admin:
        PREFIX = "/admin"
        DASHBOARD_STATS = "/dashboard/stats"
        # ... (more paths)
```

## Files Refactored

### 1. `app/api/v1/__init__.py`
**Before:**
```python
router = APIRouter(prefix="/api/v1")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.PREFIX_V1)
```

### 2. `app/api/v1/endpoints/auth.py`
**Before:**
```python
router = APIRouter(prefix="/auth", tags=["v1-auth"])

@router.post("/register")
@router.post("/login")
@router.put("/profile/{user_id}")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.Auth.PREFIX, tags=["v1-auth"])

@router.post(APIPaths.Auth.REGISTER)
@router.post(APIPaths.Auth.LOGIN)
@router.put(APIPaths.Auth.PROFILE_BY_ID)
```

### 3. `app/api/v1/endpoints/chat.py`
**Before:**
```python
router = APIRouter(prefix="/chat", tags=["v1-chat"])

@router.post("/message")
@router.get("/{session_id}/history")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.Chat.PREFIX, tags=["v1-chat"])

@router.post(APIPaths.Chat.SEND_MESSAGE)
@router.get(APIPaths.Chat.HISTORY)
```

### 4. `app/api/v1/endpoints/academic.py`
**Before:**
```python
router = APIRouter(prefix="/academic", tags=["v1-academic"])

@router.get("/grades/{student_id}")
@router.get("/schedule/{student_id}")
@router.get("/subjects")
@router.get("/subjects/search")
@router.get("/notifications/{user_id}")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.Academic.PREFIX, tags=["v1-academic"])

@router.get(APIPaths.Academic.STUDENT_GRADES)
@router.get(APIPaths.Academic.STUDENT_SCHEDULE)
@router.get(APIPaths.Academic.SUBJECTS)
@router.get(APIPaths.Academic.SUBJECTS_SEARCH)
@router.get(APIPaths.Academic.NOTIFICATIONS)
```

### 5. `app/api/v1/endpoints/support.py`
**Before:**
```python
router = APIRouter(prefix="/support", tags=["v1-support"])

@router.post("/request")
@router.get("/requests/{student_id}")
@router.get("/advisor/{advisor_id}/students")
@router.get("/student/{student_id}/profile")
@router.post("/reply")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.Support.PREFIX, tags=["v1-support"])

@router.post(APIPaths.Support.SUBMIT_REQUEST)
@router.get(APIPaths.Support.STUDENT_REQUESTS)
@router.get(APIPaths.Support.ADVISOR_STUDENTS)
@router.get(APIPaths.Support.STUDENT_PROFILE)
@router.post(APIPaths.Support.REPLY)
```

### 6. `app/api/v1/endpoints/admin.py`
**Before:**
```python
router = APIRouter(prefix="/admin", tags=["v1-admin"])

@router.get("/dashboard/stats")
@router.get("/users")
@router.post("/users/{user_id}/ban")
@router.post("/users/{user_id}/unban")
@router.post("/users/{user_id}/assign-role")
@router.get("/workflows")
@router.post("/workflows")
@router.put("/workflows/{workflow_id}")
@router.delete("/workflows/{workflow_id}")
@router.put("/settings")
```

**After:**
```python
from app.core.api_paths import APIPaths

router = APIRouter(prefix=APIPaths.Admin.PREFIX, tags=["v1-admin"])

@router.get(APIPaths.Admin.DASHBOARD_STATS)
@router.get(APIPaths.Admin.LIST_USERS)
@router.post(APIPaths.Admin.BAN_USER)
@router.post(APIPaths.Admin.UNBAN_USER)
@router.post(APIPaths.Admin.ASSIGN_ROLE)
@router.get(APIPaths.Admin.LIST_WORKFLOWS)
@router.post(APIPaths.Admin.CREATE_WORKFLOW)
@router.put(APIPaths.Admin.UPDATE_WORKFLOW)
@router.delete(APIPaths.Admin.DELETE_WORKFLOW)
@router.put(APIPaths.Admin.UPDATE_SETTING)
```

## Key Benefits

✓ **Single Source of Truth**: All paths defined in one location (`app/core/api_paths.py`)
✓ **No Double Slashes**: Hierarchical structure prevents concatenation errors
✓ **Maintainability**: Easy to update paths globally without searching through multiple files
✓ **IDE Support**: Autocomplete and refactoring support for constants
✓ **Documentation**: Clear, organized structure documenting all available endpoints
✓ **Type Safety**: Constants prevent typos and provide static checking
✓ **Backward Compatible**: Business logic unchanged; only path reference implementation changed

## Verification

All endpoint files have been refactored and tested:
- ✓ APIPaths constants import successfully
- ✓ All route decorators use APIPaths constants
- ✓ All router prefixes use APIPaths.PREFIX
- ✓ No hardcoded strings remain in endpoint files

## Summary of Changes

| Aspect | Before | After |
|--------|--------|-------|
| Hardcoded paths | Scattered across 5 endpoint files | Centralized in `api_paths.py` |
| Path updates | Find & replace across multiple files | Single edit in `api_paths.py` |
| Consistency risk | High (manual string matching) | Low (type-safe constants) |
| Code duplication | High (paths repeated) | Zero (single definition) |


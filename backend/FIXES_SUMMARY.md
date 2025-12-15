# Fix Summary: Register và Login Issues

## Vấn đề đã xác định
1. **Register endpoint trả về success nhưng không tạo user trong database**: Endpoint `/api/v1/auth/register` trả về response thành công nhưng dữ liệu user không được lưu vào database
2. **Login endpoint báo lỗi validation**: Endpoint `/api/v1/auth/login` báo lỗi 422 "Field required" cho email mặc dù chỉ gửi username và password

## Nguyên nhân

### Vấn đề 1: Transaction không được commit
**File**: `app/services/auth_service.py` - Method `register()`

**Lỗi gốc**: Code sử dụng `db.begin_nested()` (transaction savepoint lồng nhau) nhưng không commit:
```python
with db.begin_nested():
    # ... tạo user, profile, settings
    # Không có commit ở đây!
```

Savepoint không được commit ra transaction chính, nên dữ liệu không được lưu vào database.

**Tương tự**: Method `update_profile()` cũng có cùng vấn đề.

### Vấn đề 2: LoginRequest schema không xác định Optional fields đúng cách
**File**: `app/schemas/auth.py` - Class `LoginRequest`

**Lỗi gốc**: Pydantic không nhận dạng fields là Optional khi không sử dụng `Field()`:
```python
class LoginRequest(BaseModel):
    username: Optional[str]  # ❌ Pydantic vẫn yêu cầu
    email: Optional[str]     # ❌ Pydantic vẫn yêu cầu
```

## Giải pháp

### Fix 1: Commit transaction và tránh lazy loading sau commit
**File**: `app/services/auth_service.py`

```python
def register(self, db: Session, payload: RegisterRequest) -> dict:
    logger.info("Registering user %s", payload.username)
    hashed = _hash_password(payload.password)
    user = UserAccount(username=payload.username, password_hash=hashed, email=payload.email, status="ACTIVE")
    db.add(user)
    db.flush()

    profile = UserProfile(user_id=user.user_id)
    db.add(profile)

    default_settings = [...]
    db.execute(insert(SystemSetting).values(default_settings))
    
    # ✅ Store values trước commit (session sẽ expire attributes sau commit)
    user_id = user.user_id
    username = user.username
    email = user.email
    
    # ✅ Commit transaction
    db.commit()
    
    logger.info("User %s created (id=%s)", username, user_id)
    return {"data": AuthResponse(user_id=user_id, username=username, email=email).model_dump(), "message": "Success", "error_code": None}
```

**Thay đổi chính**:
- Loại bỏ `db.begin_nested()` wrapper
- Lưu trữ values trước commit
- Thêm `db.commit()` để persist dữ liệu

### Fix 2: Xác định Optional fields đúng cách
**File**: `app/schemas/auth.py`

```python
class LoginRequest(BaseModel):
    username: Optional[str] = Field(None)  # ✅ Sử dụng Field(None)
    email: Optional[str] = Field(None)     # ✅ Sử dụng Field(None)
    password: str = Field(..., min_length=6)

    @model_validator(mode="before")
    @classmethod
    def username_or_email(cls, values):
        if (values.get("username") is None) and (values.get("email") is None):
            raise ValueError("username or email is required")
        return values
```

### Fix 3: Tránh lazy loading relationships khi đặc cần
**File**: `app/services/auth_service.py` - Method `login()`

```python
def login(self, db: Session, payload: LoginRequest) -> dict:
    q = None
    if payload.username:
        q = select(UserAccount).where(UserAccount.username == payload.username)
    else:
        q = select(UserAccount).where(UserAccount.email == payload.email)
    
    user = db.execute(q).scalar_one_or_none()
    if user is None:
        logger.warning("Login failed: user not found")
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    # ✅ Extract values ngay để tránh lazy loading
    user_id = user.user_id
    username = user.username
    email = user.email
    password_hash = user.password_hash
    
    if not _verify_password(password_hash or "", payload.password):
        logger.warning("Login failed: wrong password for user %s", user_id)
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    logger.info("User %s logged in", user_id)
    token = self._create_access_token(user_id)
    data = AuthResponse(user_id=user_id, username=username, email=email).model_dump()
    data["access_token"] = token
    return {"data": data, "message": "Success", "error_code": None}
```

## Test Results

✅ **Register test pass**: User được tạo thành công trong database
✅ **Login test pass**: Login hoạt động với username/password
✅ **Data persistence**: Dữ liệu được lưu trữ vĩnh viễn trong database

### Test execution output:
```
2025-12-16 04:29:57 INFO [app.services.auth_service] Registering user sinhvien_moi
2025-12-16 04:29:57 INFO [app.services.auth_service] User sinhvien_moi created (id=1)
status 200
body {'data': {'user_id': 1, 'username': 'sinhvien_moi', 'email': 'sv_moi@thanglong.edu.vn'}, 'message': 'Success', 'error_code': None}
login status 200
login body {'data': {'user_id': 1, 'username': 'sinhvien_moi', 'email': 'sv_moi@thanglong.edu.vn', 'access_token': 'token-user-1'}, 'message': 'Success', 'error_code': None}
```

## Files Modified

1. **app/services/auth_service.py**
   - Loại bỏ `db.begin_nested()` và thêm `db.commit()` trong `register()`
   - Tương tự trong `update_profile()`
   - Tránh lazy loading trong `login()` bằng cách extract values

2. **app/schemas/auth.py**
   - Fix `LoginRequest` schema: thêm `= Field(None)` cho Optional fields

3. **tests/test_register_endpoint.py**
   - Thêm test case cho login endpoint
   - Thêm các bảng cần thiết để test hoàn chỉnh

## Khuyến nghị

1. **Tài liệu**: Cập nhật documentation về flow register/login
2. **Monitoring**: Thêm logging để theo dõi transaction commits trong auth service
3. **Database migrations**: Sử dụng Alembic để quản lý schema changes

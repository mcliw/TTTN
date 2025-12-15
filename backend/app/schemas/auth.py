from __future__ import annotations

from typing import Optional, List
from pydantic import BaseModel, Field, model_validator
from datetime import datetime


class RegisterRequest(BaseModel):
    username: str = Field(..., min_length=3)
    password: str = Field(..., min_length=6)
    email: Optional[str] = Field(None)


class LoginRequest(BaseModel):
    username: Optional[str] = Field(None)
    email: Optional[str] = Field(None)
    password: str = Field(..., min_length=6)

    @model_validator(mode="before")
    @classmethod
    def username_or_email(cls, values):
        if (values.get("username") is None) and (values.get("email") is None):
            raise ValueError("username or email is required")
        return values


class ProfileUpdateRequest(BaseModel):
    full_name: Optional[str]
    bio: Optional[str]
    avatar_path: Optional[str]


class UserProfileResponse(BaseModel):
    profile_id: int
    user_id: int
    full_name: Optional[str]
    bio: Optional[str]
    avatar_url: Optional[str]


class AuthResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]


class LoginResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class TokenRefreshRequest(BaseModel):
    refresh_token: str = Field(...)


class ChangePasswordRequest(BaseModel):
    old_password: str = Field(..., min_length=6)
    new_password: str = Field(..., min_length=6)
    confirm_password: str = Field(..., min_length=6)

    @model_validator(mode="before")
    @classmethod
    def passwords_match(cls, values):
        if values.get("new_password") != values.get("confirm_password"):
            raise ValueError("new_password and confirm_password must match")
        return values


class ForgotPasswordRequest(BaseModel):
    email: str = Field(...)


class ResetPasswordRequest(BaseModel):
    token: str = Field(...)
    new_password: str = Field(..., min_length=6)
    confirm_password: str = Field(..., min_length=6)

    @model_validator(mode="before")
    @classmethod
    def passwords_match(cls, values):
        if values.get("new_password") != values.get("confirm_password"):
            raise ValueError("new_password and confirm_password must match")
        return values


class UserDetailResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]
    status: str
    created_at: datetime
    updated_at: datetime
    profile: Optional[UserProfileResponse]


class UserListResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]
    status: str
    created_at: datetime


class PermissionCheckRequest(BaseModel):
    resource: str = Field(...)
    action: str = Field(...)


class PermissionCheckResponse(BaseModel):
    allowed: bool
    resource: str
    action: str
    reason: Optional[str] = None


# Chat related schemas
class ChatMessageCreate(BaseModel):
    session_id: int = Field(...)
    user_id: int = Field(...)
    message_content: str = Field(..., min_length=1)


class ChatMessagePayload(BaseModel):
    query: str
    history: List[dict]


class PaginatedMessages(BaseModel):
    items: List[dict]
    total: int
    page: int
    size: int

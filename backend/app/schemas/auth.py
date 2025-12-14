from __future__ import annotations

from typing import Optional, List
from pydantic import BaseModel, Field, model_validator
from datetime import datetime


class RegisterRequest(BaseModel):
    username: str = Field(..., min_length=3)
    password: str = Field(..., min_length=6)
    email: Optional[str] = Field(None)


class LoginRequest(BaseModel):
    username: Optional[str]
    email: Optional[str]
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

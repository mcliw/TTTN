from __future__ import annotations

from typing import Optional, List
from pydantic import BaseModel, Field
from datetime import datetime


class SupportRequestCreate(BaseModel):
    user_id: int = Field(..., gt=0)
    title: str = Field(..., min_length=1, max_length=255)
    description: str = Field(..., min_length=1)
    category: Optional[str] = None


class SupportRequestResponse(BaseModel):
    feedback_id: int
    user_id: int
    title: Optional[str]
    description: str
    status: str
    created_at: datetime


class SupportRequestListResponse(BaseModel):
    items: List[SupportRequestResponse]
    total: int
    page: int
    size: int


class StudentProfileResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]
    full_name: Optional[str]
    phone: Optional[str]
    department_id: Optional[int]
    avatar_url: Optional[str]


class StudentListResponse(BaseModel):
    items: List[StudentProfileResponse]
    total: int
    page: int
    size: int


class SupportReplyCreate(BaseModel):
    feedback_id: int = Field(..., gt=0)
    reply_message: str = Field(..., min_length=1)

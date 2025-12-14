from __future__ import annotations

from typing import Optional, List
from pydantic import BaseModel, Field
from datetime import datetime


class DashboardStats(BaseModel):
    total_users: int
    active_sessions_today: int
    error_count: int
    total_support_requests: int


class UserManagementResponse(BaseModel):
    user_id: int
    username: str
    email: Optional[str]
    status: str
    created_at: datetime


class UserListResponse(BaseModel):
    items: List[UserManagementResponse]
    total: int
    page: int
    size: int


class UserUpdateRequest(BaseModel):
    status: Optional[str] = None
    role_id: Optional[int] = None


class WorkflowConfigCreate(BaseModel):
    workflow_name: str = Field(..., min_length=1)
    description: Optional[str]
    endpoint_url: str = Field(..., min_length=1)
    auth_token: Optional[str]
    status: str = "ACTIVE"


class WorkflowConfigResponse(BaseModel):
    workflow_id: int
    workflow_name: str
    description: Optional[str]
    endpoint_url: str
    status: str
    created_at: datetime


class WorkflowConfigListResponse(BaseModel):
    items: List[WorkflowConfigResponse]
    total: int
    page: int
    size: int


class SystemSettingUpdate(BaseModel):
    key_name: str = Field(..., min_length=1)
    value: str = Field(..., min_length=1)
    description: Optional[str]

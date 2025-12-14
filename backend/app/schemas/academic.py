from __future__ import annotations

from typing import Optional, List
from pydantic import BaseModel, Field
from datetime import datetime


class SubjectResponse(BaseModel):
    data_id: int
    intent_id: int
    input_text: str
    label: str


class GradeInfo(BaseModel):
    subject: str
    grade: float
    credits: int


class ScheduleInfo(BaseModel):
    subject: str
    time: str
    room: str
    lecturer: str


class NotificationResponse(BaseModel):
    notification_id: int
    title: str
    message: str
    status: str
    created_at: datetime


class NotificationListResponse(BaseModel):
    items: List[NotificationResponse]
    total: int
    page: int
    size: int

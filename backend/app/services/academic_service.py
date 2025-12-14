from __future__ import annotations

import logging
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.repositories.academic_repo import AcademicRepository
from app.schemas.academic import SubjectResponse, GradeInfo, ScheduleInfo, NotificationListResponse, NotificationResponse

logger = logging.getLogger(__name__)


class AcademicService:
    def __init__(self, db: Session):
        self.repo = AcademicRepository(db)
        self.db = db

    def get_grades_for_student(self, student_id: int) -> Dict[str, Any]:
        """Return mock grades for a student (UC9)."""
        logger.info("Fetching grades for student %s", student_id)
        # Mock data: In production, this would query a real academic database
        grades = [
            GradeInfo(subject="Data Structures", grade=8.5, credits=3),
            GradeInfo(subject="Algorithms", grade=9.0, credits=4),
            GradeInfo(subject="Database Design", grade=8.0, credits=3),
        ]
        return {
            "data": [g.model_dump() for g in grades],
            "message": "Success",
            "error_code": None,
        }

    def get_schedule_for_student(self, student_id: int) -> Dict[str, Any]:
        """Return mock schedule for a student (UC9)."""
        logger.info("Fetching schedule for student %s", student_id)
        # Mock data
        schedule = [
            ScheduleInfo(subject="Data Structures", time="Monday 09:00-11:00", room="Room 101", lecturer="Prof. A"),
            ScheduleInfo(subject="Algorithms", time="Wednesday 14:00-16:00", room="Room 202", lecturer="Prof. B"),
            ScheduleInfo(subject="Database Design", time="Friday 10:00-12:00", room="Room 303", lecturer="Prof. C"),
        ]
        return {
            "data": [s.model_dump() for s in schedule],
            "message": "Success",
            "error_code": None,
        }

    def get_subjects(self, limit: int = 50) -> Dict[str, Any]:
        """Fetch available subjects (UC11)."""
        logger.info("Fetching subjects (limit=%s)", limit)
        items = self.repo.get_subjects(limit=limit)
        subjects = [
            SubjectResponse(data_id=s.data_id, intent_id=s.intent_id, input_text=s.input_text, label=s.label)
            for s in items
        ]
        return {
            "data": [s.model_dump() for s in subjects],
            "message": "Success",
            "error_code": None,
        }

    def search_subjects(self, query: str) -> Dict[str, Any]:
        """Search subjects by label (UC11)."""
        logger.info("Searching subjects: %s", query)
        if not query or len(query.strip()) < 2:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Query must be at least 2 characters")

        items = self.repo.get_subjects_by_label(query)
        subjects = [
            SubjectResponse(data_id=s.data_id, intent_id=s.intent_id, input_text=s.input_text, label=s.label)
            for s in items
        ]
        return {
            "data": [s.model_dump() for s in subjects],
            "message": "Success",
            "error_code": None,
        }

    def get_notifications(self, user_id: int, page: int = 1, size: int = 20) -> Dict[str, Any]:
        """Fetch notifications for a user (UC10, UC17)."""
        logger.info("Fetching notifications for user %s (page=%s, size=%s)", user_id, page, size)
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination")

        items, total = self.repo.get_notifications_for_user(user_id, page=page, size=size)
        notifs = [
            NotificationResponse(
                notification_id=n.notification_id,
                title=n.title,
                message=n.message,
                status=n.status,
                created_at=n.created_at,
            )
            for n in items
        ]
        return {
            "data": NotificationListResponse(items=notifs, total=total, page=page, size=size).model_dump(),
            "message": "Success",
            "error_code": None,
        }

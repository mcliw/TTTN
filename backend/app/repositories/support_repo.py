from __future__ import annotations

import logging
from typing import Optional, List
from sqlalchemy import select, func
from sqlalchemy.orm import Session, selectinload

from app.models import SystemFeedback, UserAccount, SystemNotification, UserProfile

logger = logging.getLogger(__name__)


class SupportRepository:
    def __init__(self, db: Session):
        self.db = db

    def create_support_request(self, user_id: int, session_id: int, comment: str, rating: int = 0) -> SystemFeedback:
        """Create a support/feedback request."""
        feedback = SystemFeedback(user_id=user_id, session_id=session_id, comment=comment, rating=rating)
        self.db.add(feedback)
        return feedback

    def get_support_requests_for_user(self, user_id: int, page: int = 1, size: int = 20) -> tuple[List[SystemFeedback], int]:
        """Fetch paginated support requests for a user."""
        total_stmt = select(func.count()).select_from(SystemFeedback).where(SystemFeedback.user_id == user_id)
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(SystemFeedback)
            .where(SystemFeedback.user_id == user_id)
            .order_by(SystemFeedback.created_at.desc())
            .options(selectinload(SystemFeedback.user))
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().unique().all()
        return items, total

    def get_all_support_requests(self, page: int = 1, size: int = 20) -> tuple[List[SystemFeedback], int]:
        """Fetch all support requests with pagination."""
        total_stmt = select(func.count()).select_from(SystemFeedback)
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(SystemFeedback)
            .order_by(SystemFeedback.created_at.desc())
            .options(selectinload(SystemFeedback.user))
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().unique().all()
        return items, total

    def get_assigned_students(self, advisor_id: int, page: int = 1, size: int = 20) -> tuple[List[UserAccount], int]:
        """Fetch students assigned to an advisor (by department or directly assigned)."""
        # Mock: Get students from the same department as advisor
        advisor = self.db.execute(select(UserAccount).where(UserAccount.user_id == advisor_id).options(selectinload(UserAccount.profile))).scalar_one_or_none()
        if not advisor or not advisor.profile:
            return [], 0

        total_stmt = (
            select(func.count())
            .select_from(UserAccount)
            .join(UserProfile, UserAccount.user_id == UserProfile.user_id)
            .where(UserProfile.department_id == advisor.profile.department_id, UserAccount.user_id != advisor_id)
        )
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(UserAccount)
            .join(UserProfile, UserAccount.user_id == UserProfile.user_id)
            .where(UserProfile.department_id == advisor.profile.department_id, UserAccount.user_id != advisor_id)
            .options(selectinload(UserAccount.profile))
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().unique().all()
        return items, total

    def get_student_detail(self, student_id: int) -> Optional[UserAccount]:
        """Fetch a student's full profile."""
        stmt = select(UserAccount).where(UserAccount.user_id == student_id).options(selectinload(UserAccount.profile))
        return self.db.execute(stmt).scalar_one_or_none()

    def create_notification_for_user(self, receiver_id: int, title: str, message: str) -> SystemNotification:
        """Create a notification for a user."""
        notif = SystemNotification(receiver_id=receiver_id, title=title, message=message, status="UNREAD")
        self.db.add(notif)
        return notif

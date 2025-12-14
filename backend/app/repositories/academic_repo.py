from __future__ import annotations

import logging
from typing import Optional, List
from sqlalchemy import select, func
from sqlalchemy.orm import Session, selectinload

from app.models import AITrainingDataset, SystemNotification, UserAccount

logger = logging.getLogger(__name__)


class AcademicRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_subjects(self, limit: int = 50) -> List[AITrainingDataset]:
        """Fetch subject training data (mock subject list)."""
        stmt = select(AITrainingDataset).limit(limit)
        return self.db.execute(stmt).scalars().all()

    def get_subjects_by_label(self, label: str) -> List[AITrainingDataset]:
        """Search subjects by label."""
        stmt = select(AITrainingDataset).where(AITrainingDataset.label.ilike(f"%{label}%")).limit(50)
        return self.db.execute(stmt).scalars().all()

    def get_notifications_for_user(self, user_id: int, page: int = 1, size: int = 20) -> tuple[List[SystemNotification], int]:
        """Fetch paginated notifications for a user."""
        total_stmt = select(func.count()).select_from(SystemNotification).where(SystemNotification.receiver_id == user_id)
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(SystemNotification)
            .where(SystemNotification.receiver_id == user_id)
            .order_by(SystemNotification.created_at.desc())
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().all()
        return items, total

    def create_notification(self, receiver_id: int, title: str, message: str, status: str = "UNREAD") -> SystemNotification:
        """Create a notification for a user."""
        notif = SystemNotification(receiver_id=receiver_id, title=title, message=message, status=status)
        self.db.add(notif)
        return notif

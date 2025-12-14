from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from .base import Base


class SystemNotification(Base):
    __tablename__ = "system_notification"

    notification_id = Column(Integer, primary_key=True, index=True)
    receiver_id = Column(Integer, ForeignKey("user_account.user_id"), index=True)
    title = Column(String(255))
    message = Column(Text)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

    receiver = relationship(
        "UserAccount",
        back_populates="notifications",
        lazy="selectin",
        uselist=False,
    )

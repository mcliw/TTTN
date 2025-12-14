from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class SystemNotification(Base):
    __tablename__ = "system_notification"

    notification_id = Column(Integer, primary_key=True, index=True)
    receiver_id = Column(Integer, index=True)
    title = Column(String(255))
    message = Column(Text)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

    receiver = relationship(
        "UserAccount",
        primaryjoin="SystemNotification.receiver_id==UserAccount.user_id",
        back_populates="notifications",
        lazy="selectin",
        uselist=False,
    )

from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class SystemFeedback(Base):
    __tablename__ = "system_feedback"

    feedback_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    session_id = Column(Integer, index=True)
    rating = Column(Integer)
    comment = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship(
        "UserAccount",
        primaryjoin="SystemFeedback.user_id==UserAccount.user_id",
        back_populates="feedbacks",
        lazy="selectin",
        uselist=False,
    )
    session = relationship(
        "ChatSession",
        primaryjoin="SystemFeedback.session_id==ChatSession.session_id",
        lazy="selectin",
        uselist=False,
    )

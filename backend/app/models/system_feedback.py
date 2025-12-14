from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from .base import Base


class SystemFeedback(Base):
    __tablename__ = "system_feedback"

    feedback_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_account.user_id"), index=True)
    session_id = Column(Integer, ForeignKey("chat_session.session_id"), index=True)
    rating = Column(Integer)
    comment = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship(
        "UserAccount",
        back_populates="feedbacks",
        lazy="selectin",
        uselist=False,
    )
    session = relationship(
        "ChatSession",
        lazy="selectin",
        uselist=False,
    )

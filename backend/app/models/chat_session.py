from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from .base import Base


class ChatSession(Base):
    __tablename__ = "chat_session"

    session_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_account.user_id"), index=True)
    start_time = Column(DateTime, default=datetime.utcnow)
    end_time = Column(DateTime)
    total_messages = Column(Integer, default=0)
    status = Column(String(50))

    user = relationship(
        "UserAccount",
        back_populates="sessions",
        lazy="selectin",
    )
    messages = relationship(
        "ChatMessage",
        primaryjoin="ChatSession.session_id==ChatMessage.session_id",
        back_populates="session",
        lazy="selectin",
    )

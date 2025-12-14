from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class ChatSession(Base):
    __tablename__ = "chat_session"

    session_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    start_time = Column(DateTime, default=datetime.utcnow)
    end_time = Column(DateTime)
    total_messages = Column(Integer, default=0)
    status = Column(String(50))

    user = relationship(
        "UserAccount",
        primaryjoin="ChatSession.user_id==UserAccount.user_id",
        back_populates="sessions",
        lazy="selectin",
    )
    messages = relationship(
        "ChatMessage",
        primaryjoin="ChatSession.session_id==ChatMessage.session_id",
        back_populates="session",
        lazy="selectin",
    )

from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from .base import Base


class ChatMessage(Base):
    __tablename__ = "chat_message"

    message_id = Column(Integer, primary_key=True, index=True)
    session_id = Column(Integer, index=True)
    intent_id = Column(Integer, index=True)
    sender_type = Column(String(50))
    content = Column(Text)
    entity_detected = Column(JSONB)
    created_at = Column(DateTime, default=datetime.utcnow)
    status = Column(String(50))

    session = relationship(
        "ChatSession",
        primaryjoin="ChatMessage.session_id==ChatSession.session_id",
        back_populates="messages",
        lazy="selectin",
    )
    intent = relationship(
        "ChatIntent",
        primaryjoin="ChatMessage.intent_id==ChatIntent.intent_id",
        back_populates="messages",
        lazy="selectin",
    )

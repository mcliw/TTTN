from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class ChatIntent(Base):
    __tablename__ = "chat_intent"

    intent_id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, index=True)
    model_id = Column(Integer, index=True)
    intent_name = Column(String(255))
    description = Column(Text)
    example_phrases = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    messages = relationship(
        "ChatMessage",
        back_populates="intent",
        lazy="selectin",
    )
    entities = relationship(
        "ChatEntity",
        back_populates="intent",
        lazy="selectin",
    )

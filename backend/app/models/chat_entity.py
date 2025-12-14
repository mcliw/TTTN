from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class ChatEntity(Base):
    __tablename__ = "chat_entity"

    entity_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    entity_name = Column(String(255))
    entity_type = Column(String(100))
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    intent = relationship(
        "ChatIntent",
        primaryjoin="ChatEntity.intent_id==ChatIntent.intent_id",
        back_populates="entities",
        lazy="selectin",
    )

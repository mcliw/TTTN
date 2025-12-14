from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime

from .base import Base


class SystemResponseTemplate(Base):
    __tablename__ = "system_response_template"

    template_id = Column(Integer, primary_key=True, index=True)
    entity_id = Column(Integer, index=True)
    template_type = Column(String(100))
    content = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

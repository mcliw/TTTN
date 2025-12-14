from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Float, DateTime

from .base import Base


class AIModelConfig(Base):
    __tablename__ = "ai_model_config"

    model_id = Column(Integer, primary_key=True, index=True)
    model_name = Column(String(255))
    provider = Column(String(255))
    api_key = Column(String(1024))
    temperature = Column(Float)
    max_tokens = Column(Integer)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

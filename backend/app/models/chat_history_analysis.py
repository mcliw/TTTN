from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, Float, DateTime, String
from sqlalchemy.dialects.postgresql import JSONB

from .base import Base


class ChatHistoryAnalysis(Base):
    __tablename__ = "chat_history_analysis"

    analysis_id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, index=True)
    intent_id = Column(Integer, index=True)
    confidence_score = Column(Float)
    entities_json = Column(JSONB)
    processing_time = Column(Float)
    model_used = Column(String(255))
    analyzed_at = Column(DateTime, default=datetime.utcnow)

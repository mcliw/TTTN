from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime

from .base import Base


class AITrainingDataset(Base):
    __tablename__ = "ai_training_dataset"

    data_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    input_text = Column(Text)
    label = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)

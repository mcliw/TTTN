from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime

from .base import Base


class AIVectorIndex(Base):
    __tablename__ = "ai_vector_index"

    vector_id = Column(Integer, primary_key=True, index=True)
    source_table = Column(String(255), index=True)
    source_record_id = Column(Integer, index=True)
    embedding_model = Column(String(255))
    chunk_index = Column(Integer)
    content_hash = Column(String(255), index=True)
    created_at = Column(DateTime, default=datetime.utcnow)

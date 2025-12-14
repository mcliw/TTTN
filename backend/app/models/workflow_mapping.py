from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, Boolean, DateTime

from .base import Base


class WorkflowMapping(Base):
    __tablename__ = "workflow_mapping"

    mapping_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    workflow_id = Column(Integer, index=True)
    active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from .base import Base


class SystemErrorLog(Base):
    __tablename__ = "system_error_log"

    error_id = Column(Integer, primary_key=True, index=True)
    exec_id = Column(Integer, ForeignKey("workflow_execution_log.exec_id"), index=True)
    source = Column(String(255))
    message = Column(Text)
    stack_trace = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    execution = relationship(
        "WorkflowExecutionLog",
        back_populates="errors",
        lazy="selectin",
        uselist=False,
    )

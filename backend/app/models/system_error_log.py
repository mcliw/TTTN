from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class SystemErrorLog(Base):
    __tablename__ = "system_error_log"

    error_id = Column(Integer, primary_key=True, index=True)
    exec_id = Column(Integer, index=True)
    source = Column(String(255))
    message = Column(Text)
    stack_trace = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    execution = relationship(
        "WorkflowExecutionLog",
        primaryjoin="SystemErrorLog.exec_id==WorkflowExecutionLog.exec_id",
        back_populates="errors",
        lazy="selectin",
        uselist=False,
    )

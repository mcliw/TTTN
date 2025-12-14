from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from .base import Base


class WorkflowExecutionLog(Base):
    __tablename__ = "workflow_execution_log"

    exec_id = Column(Integer, primary_key=True, index=True)
    workflow_id = Column(Integer, ForeignKey("workflow_config.workflow_id"), index=True)
    user_id = Column(Integer, ForeignKey("user_account.user_id"), index=True)
    input_data = Column(JSONB)
    output_data = Column(JSONB)
    status = Column(String(50))
    executed_at = Column(DateTime, default=datetime.utcnow)
    duration_ms = Column(Integer)

    workflow = relationship(
        "WorkflowConfig",
        primaryjoin="WorkflowExecutionLog.workflow_id==WorkflowConfig.workflow_id",
        back_populates="executions",
        lazy="selectin",
    )
    errors = relationship(
        "SystemErrorLog",
        primaryjoin="WorkflowExecutionLog.exec_id==SystemErrorLog.exec_id",
        back_populates="execution",
        lazy="selectin",
    )

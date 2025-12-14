from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class WorkflowConfig(Base):
    __tablename__ = "workflow_config"

    workflow_id = Column(Integer, primary_key=True, index=True)
    created_by = Column(Integer, index=True)
    workflow_name = Column(String(255))
    description = Column(Text)
    endpoint_url = Column(String(1024))
    auth_token = Column(String(1024))
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

    creator = relationship(
        "UserAccount",
        primaryjoin="WorkflowConfig.created_by==UserAccount.user_id",
        back_populates="workflows",
        lazy="selectin",
        uselist=False,
    )
    executions = relationship(
        "WorkflowExecutionLog",
        primaryjoin="WorkflowConfig.workflow_id==WorkflowExecutionLog.workflow_id",
        back_populates="workflow",
        lazy="selectin",
    )

from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class UserAccount(Base):
    __tablename__ = "user_account"

    user_id = Column(Integer, primary_key=True, index=True)
    role_id = Column(Integer, index=True)
    username = Column(String(150), nullable=False)
    password_hash = Column(String(512))
    email = Column(String(255), index=True)
    auth_type = Column(String(50))
    external_auth = Column(Boolean, default=False)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    oauth_identities = relationship(
        "UserOAuthIdentity",
        primaryjoin="UserAccount.user_id==UserOAuthIdentity.user_id",
        back_populates="user",
        lazy="selectin",
    )
    profile = relationship(
        "UserProfile",
        primaryjoin="UserAccount.user_id==UserProfile.user_id",
        back_populates="user",
        uselist=False,
        lazy="selectin",
    )
    sessions = relationship(
        "ChatSession",
        primaryjoin="UserAccount.user_id==ChatSession.user_id",
        back_populates="user",
        lazy="selectin",
    )
    feedbacks = relationship(
        "SystemFeedback",
        primaryjoin="UserAccount.user_id==SystemFeedback.user_id",
        back_populates="user",
        lazy="selectin",
    )
    notifications = relationship(
        "SystemNotification",
        primaryjoin="UserAccount.user_id==SystemNotification.receiver_id",
        back_populates="receiver",
        lazy="selectin",
    )
    workflows = relationship(
        "WorkflowConfig",
        primaryjoin="UserAccount.user_id==WorkflowConfig.created_by",
        back_populates="creator",
        lazy="selectin",
    )

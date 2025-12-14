from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship, foreign

from .base import Base


class UserOAuthIdentity(Base):
    __tablename__ = "user_oauth_identity"

    oauth_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user_account.user_id"), index=True)
    provider = Column(String(50))
    provider_user_id = Column(String(255), index=True)
    email = Column(String(255), index=True)
    access_token = Column(Text)
    refresh_token = Column(Text)
    token_expired_at = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship(
        "UserAccount",
        back_populates="oauth_identities",
        lazy="selectin",
    )

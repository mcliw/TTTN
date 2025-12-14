from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from .base import Base


class UserOAuthIdentity(Base):
    __tablename__ = "user_oauth_identity"

    oauth_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
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
        primaryjoin="UserOAuthIdentity.user_id==UserAccount.user_id",
        back_populates="oauth_identities",
        lazy="selectin",
    )

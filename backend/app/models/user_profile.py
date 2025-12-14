from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship

from .base import Base


class UserProfile(Base):
    __tablename__ = "user_profile"

    profile_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    department_id = Column(Integer, index=True)
    full_name = Column(String(255))
    phone = Column(String(50))
    avatar_url = Column(String(1024))
    position = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship(
        "UserAccount",
        primaryjoin="UserProfile.user_id==UserAccount.user_id",
        back_populates="profile",
        lazy="selectin",
        uselist=False,
    )

from __future__ import annotations

from sqlalchemy import Column, Integer, String, Text

from .base import Base


class UserRole(Base):
    __tablename__ = "user_role"

    role_id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(150))
    description = Column(Text)

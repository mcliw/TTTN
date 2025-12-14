from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, Integer, String, Text, DateTime

from .base import Base


class SystemSetting(Base):
    __tablename__ = "system_setting"

    setting_id = Column(Integer, primary_key=True, index=True)
    key_name = Column(String(255), index=True)
    value = Column(Text)
    description = Column(Text)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

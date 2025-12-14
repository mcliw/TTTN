from sqlalchemy import Column, Integer, String, Text

from .base import Base


class CommonStatus(Base):
    __tablename__ = "common_status"

    status_id = Column(Integer, primary_key=True, index=True)
    status_code = Column(String(100))
    description = Column(Text)

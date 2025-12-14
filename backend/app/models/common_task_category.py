from sqlalchemy import Column, Integer, String, Text

from .base import Base


class CommonTaskCategory(Base):
    __tablename__ = "common_task_category"

    category_id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String(255))
    description = Column(Text)

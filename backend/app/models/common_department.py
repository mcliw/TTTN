from sqlalchemy import Column, Integer, String, Text

from .base import Base


class CommonDepartment(Base):
    __tablename__ = "common_department"

    department_id = Column(Integer, primary_key=True, index=True)
    department_name = Column(String(255))
    description = Column(Text)

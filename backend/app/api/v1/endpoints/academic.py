from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.academic_service import AcademicService
from app.schemas.academic import SubjectResponse

router = APIRouter(prefix="/v1/academic", tags=["v1-academic"])
logger = logging.getLogger(__name__)


@router.get("/grades/{student_id}")
def get_student_grades(student_id: int, db: Session = Depends(get_db)):
    """Get student grades (UC9)."""
    service = AcademicService(db)
    return service.get_grades_for_student(student_id)


@router.get("/schedule/{student_id}")
def get_student_schedule(student_id: int, db: Session = Depends(get_db)):
    """Get student schedule (UC9)."""
    service = AcademicService(db)
    return service.get_schedule_for_student(student_id)


@router.get("/subjects")
def list_subjects(limit: int = Query(50, ge=1, le=100), db: Session = Depends(get_db)):
    """Get list of available subjects (UC11)."""
    service = AcademicService(db)
    return service.get_subjects(limit=limit)


@router.get("/subjects/search")
def search_subjects(query: str = Query(..., min_length=2), db: Session = Depends(get_db)):
    """Search subjects by label (UC11)."""
    service = AcademicService(db)
    return service.search_subjects(query)


@router.get("/notifications/{user_id}")
def get_notifications(user_id: int, page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get notifications for a user (UC10, UC17)."""
    service = AcademicService(db)
    return service.get_notifications(user_id, page=page, size=size)

from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.support_service import SupportService
from app.schemas.support import SupportRequestCreate, SupportReplyCreate

router = APIRouter(prefix="/v1/support", tags=["v1-support"])
logger = logging.getLogger(__name__)


@router.post("/request")
def submit_request(payload: SupportRequestCreate, db: Session = Depends(get_db)):
    """Student submits a support request (UC12)."""
    service = SupportService(db)
    return service.submit_support_request(payload)


@router.get("/requests/{student_id}")
def get_student_requests(student_id: int, page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get support requests for a student."""
    service = SupportService(db)
    return service.get_student_requests(student_id, page=page, size=size)


@router.get("/advisor/{advisor_id}/students")
def get_assigned_students(advisor_id: int, page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get students assigned to an advisor (UC14)."""
    service = SupportService(db)
    return service.get_advisor_assigned_students(advisor_id, page=page, size=size)


@router.get("/student/{student_id}/profile")
def get_student_profile_view(student_id: int, advisor_id: int = Query(...), db: Session = Depends(get_db)):
    """Get detailed profile of a student (UC15)."""
    service = SupportService(db)
    return service.get_student_profile(advisor_id, student_id)


@router.post("/reply")
def reply_to_request(advisor_id: int = Query(...), payload: SupportReplyCreate = None, db: Session = Depends(get_db)):
    """Advisor replies to a support request (UC16)."""
    if payload is None:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="Request body required")
    service = SupportService(db)
    return service.reply_to_request(advisor_id, payload)

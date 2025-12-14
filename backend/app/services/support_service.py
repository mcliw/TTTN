from __future__ import annotations

import logging
from typing import Dict, Any
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.repositories.support_repo import SupportRepository
from app.schemas.support import SupportRequestCreate, SupportRequestResponse, SupportRequestListResponse, StudentProfileResponse, StudentListResponse, SupportReplyCreate
from app.models import UserAccount

logger = logging.getLogger(__name__)


class SupportService:
    def __init__(self, db: Session):
        self.repo = SupportRepository(db)
        self.db = db

    def submit_support_request(self, payload: SupportRequestCreate) -> Dict[str, Any]:
        """Student submits a support request (UC12)."""
        logger.info("Student %s submitting support request", payload.user_id)

        # Create feedback record (mock session_id for now)
        with self.db.begin():
            feedback = self.repo.create_support_request(
                user_id=payload.user_id,
                session_id=1,  # Mock value
                comment=payload.description,
                rating=0,
            )
            # Create notification for advisor(s) in the department
            # Mock: notify all advisors in the system
            logger.debug("Creating advisor notification for feedback %s", feedback.feedback_id)
            self.repo.create_notification_for_user(
                receiver_id=2,  # Mock advisor user_id
                title=f"New support request from student {payload.user_id}",
                message=payload.description,
            )

        resp = SupportRequestResponse(
            feedback_id=feedback.feedback_id,
            user_id=feedback.user_id,
            title=payload.title,
            description=feedback.comment,
            status="OPEN",
            created_at=feedback.created_at,
        )
        logger.info("Support request %s created", feedback.feedback_id)
        return {
            "data": resp.model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def get_student_requests(self, student_id: int, page: int = 1, size: int = 20) -> Dict[str, Any]:
        """Get support requests for a student."""
        logger.info("Fetching requests for student %s", student_id)
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination")

        items, total = self.repo.get_support_requests_for_user(student_id, page=page, size=size)
        requests = [
            SupportRequestResponse(
                feedback_id=r.feedback_id,
                user_id=r.user_id,
                title=f"Request {r.feedback_id}",
                description=r.comment,
                status="OPEN",
                created_at=r.created_at,
            )
            for r in items
        ]
        return {
            "data": StudentListResponse(items=[SupportRequestResponse(**r.model_dump()) for r in requests], total=total, page=page, size=size).model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def get_advisor_assigned_students(self, advisor_id: int, page: int = 1, size: int = 20) -> Dict[str, Any]:
        """Get list of students assigned to an advisor (UC14)."""
        logger.info("Fetching assigned students for advisor %s", advisor_id)
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination")

        items, total = self.repo.get_assigned_students(advisor_id, page=page, size=size)
        students = [
            StudentProfileResponse(
                user_id=u.user_id,
                username=u.username,
                email=u.email,
                full_name=u.profile.full_name if u.profile else None,
                phone=u.profile.phone if u.profile else None,
                department_id=u.profile.department_id if u.profile else None,
                avatar_url=u.profile.avatar_url if u.profile else None,
            )
            for u in items
        ]
        return {
            "data": StudentListResponse(items=students, total=total, page=page, size=size).model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def get_student_profile(self, advisor_id: int, student_id: int) -> Dict[str, Any]:
        """Get detailed profile of a student (UC15)."""
        logger.info("Advisor %s viewing student %s profile", advisor_id, student_id)

        student = self.repo.get_student_detail(student_id)
        if student is None:
            logger.error("Student %s not found", student_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

        student_data = StudentProfileResponse(
            user_id=student.user_id,
            username=student.username,
            email=student.email,
            full_name=student.profile.full_name if student.profile else None,
            phone=student.profile.phone if student.profile else None,
            department_id=student.profile.department_id if student.profile else None,
            avatar_url=student.profile.avatar_url if student.profile else None,
        )
        return {
            "data": student_data.model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def reply_to_request(self, advisor_id: int, payload: SupportReplyCreate) -> Dict[str, Any]:
        """Advisor replies to a support request (UC16)."""
        logger.info("Advisor %s replying to request %s", advisor_id, payload.feedback_id)

        # Fetch the feedback request to get student_id
        stmt_feedback = "SELECT user_id FROM system_feedback WHERE feedback_id = :fid"
        # For simplicity, mock the student notification
        logger.debug("Creating notification for student about reply to request %s", payload.feedback_id)
        self.repo.create_notification_for_user(
            receiver_id=1,  # Mock student_id
            title=f"Reply to your support request",
            message=payload.reply_message,
        )

        self.db.commit()
        return {
            "data": {"request_id": payload.feedback_id, "replied": True},
            "message": "Reply sent successfully",
            "error_code": None,
        }

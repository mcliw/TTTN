from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, UploadFile, File, Form
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.schemas.auth import RegisterRequest, LoginRequest, ProfileUpdateRequest
from app.services.auth_service import AuthService, FileService

router = APIRouter(prefix="/auth", tags=["auth"])
logger = logging.getLogger(__name__)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


auth_service = AuthService()


@router.post("/register")
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    return auth_service.register(db, payload)


@router.post("/login")
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    return auth_service.login(db, payload)


@router.put("/profile/{user_id}")
def update_profile(user_id: int, full_name: str | None = Form(None), bio: str | None = Form(None), avatar: UploadFile | None = File(None), db: Session = Depends(get_db)):
    payload = ProfileUpdateRequest(full_name=full_name, bio=bio)
    avatar_stream = None
    avatar_name = None
    if avatar is not None:
        avatar_stream = avatar.file
        avatar_name = avatar.filename
    return auth_service.update_profile(db, user_id, payload, avatar_stream=avatar_stream, avatar_filename=avatar_name)

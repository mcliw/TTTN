from __future__ import annotations

from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.api_paths import APIPaths
from app.schemas.auth import RegisterRequest, LoginRequest, ProfileUpdateRequest
from app.services.auth_service import AuthService
from app.repositories.user_repo import UserRepository

router = APIRouter(prefix=APIPaths.Auth.PREFIX, tags=["v1-auth"])
auth_service = AuthService()


@router.post(APIPaths.Auth.REGISTER)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    # Use repository to check existence
    repo = UserRepository(db)
    existing = repo.get_by_username_or_email(username=payload.username)
    if existing:
        raise HTTPException(status_code=400, detail="Username already exists")
    return auth_service.register(db, payload)


@router.post(APIPaths.Auth.LOGIN)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    return auth_service.login(db, payload)


@router.put(APIPaths.Auth.PROFILE_BY_ID)
def update_profile(user_id: int, full_name: str | None = Form(None), bio: str | None = Form(None), avatar: UploadFile | None = File(None), db: Session = Depends(get_db)):
    payload = ProfileUpdateRequest(full_name=full_name, bio=bio)
    avatar_stream = None
    avatar_name = None
    if avatar is not None:
        avatar_stream = avatar.file
        avatar_name = avatar.filename
    return auth_service.update_profile(db, user_id, payload, avatar_stream=avatar_stream, avatar_filename=avatar_name)

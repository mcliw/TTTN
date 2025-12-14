from __future__ import annotations

from fastapi import APIRouter, Depends, Request, HTTPException
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
async def update_profile(request: Request, user_id: int, db: Session = Depends(get_db)):
    # Support form data (multipart) when python-multipart is installed, otherwise accept JSON body
    full_name = None
    bio = None
    avatar_stream = None
    avatar_name = None
    try:
        form = await request.form()
        full_name = form.get("full_name")
        bio = form.get("bio")
        avatar = form.get("avatar")
        if avatar is not None and hasattr(avatar, "file"):
            avatar_stream = avatar.file
            avatar_name = getattr(avatar, "filename", None)
    except Exception:
        # Fallback to JSON body
        try:
            body = await request.json()
            full_name = body.get("full_name")
            bio = body.get("bio")
        except Exception:
            pass

    payload = ProfileUpdateRequest(full_name=full_name, bio=bio)
    return auth_service.update_profile(db, user_id, payload, avatar_stream=avatar_stream, avatar_filename=avatar_name)

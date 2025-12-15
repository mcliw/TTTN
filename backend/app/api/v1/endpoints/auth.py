from __future__ import annotations

from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.api_paths import APIPaths
from app.core.security import get_current_user
from app.schemas.auth import (RegisterRequest, LoginRequest, ProfileUpdateRequest, TokenRefreshRequest, 
                              ChangePasswordRequest, ForgotPasswordRequest, ResetPasswordRequest, PermissionCheckRequest)
from app.services.auth_service import AuthService
from app.repositories.user_repo import UserRepository
from app.models import UserAccount

router = APIRouter(prefix=APIPaths.Auth.PREFIX, tags=["v1-auth"])
auth_service = AuthService()


@router.post(APIPaths.Auth.REGISTER)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    repo = UserRepository(db)
    existing = repo.get_by_username_or_email(username=payload.username)
    if existing:
        raise HTTPException(status_code=400, detail="Username already exists")
    return auth_service.register(db, payload)


@router.post(APIPaths.Auth.LOGIN)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    return auth_service.login(db, payload)


@router.post(APIPaths.Auth.PREFIX + "/refresh-token")
def refresh_token(payload: TokenRefreshRequest):
    return auth_service.refresh_token(payload)


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


@router.get(APIPaths.Auth.PREFIX + "/profile")
def get_profile(current_user: UserAccount = Depends(get_current_user), db: Session = Depends(get_db)):
    """Get current user's profile information"""
    return auth_service.get_user_profile(db, current_user.user_id)


@router.get(APIPaths.Auth.PREFIX + "/profile/{user_id}")
def get_user_profile(user_id: int, db: Session = Depends(get_db)):
    """Get user profile by ID"""
    return auth_service.get_user_profile(db, user_id)


@router.get(APIPaths.Auth.PREFIX + "/users")
def get_users_list(
    limit: int = 100,
    offset: int = 0,
    admin: UserAccount = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get list of all users (requires authentication, admin preferred)"""
    # Check if user is admin
    if admin.role_id != 1:
        raise HTTPException(status_code=403, detail="Admin access required")
    return auth_service.get_users_list(db, limit=limit, offset=offset)


@router.post(APIPaths.Auth.PREFIX + "/change-password")
def change_password(
    payload: ChangePasswordRequest,
    current_user: UserAccount = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Change user password"""
    return auth_service.change_password(db, current_user.user_id, payload)


@router.post(APIPaths.Auth.PREFIX + "/forgot-password")
def forgot_password(payload: ForgotPasswordRequest, db: Session = Depends(get_db)):
    """Request password reset"""
    return auth_service.forgot_password(db, payload)


@router.post(APIPaths.Auth.PREFIX + "/reset-password")
def reset_password(payload: ResetPasswordRequest, db: Session = Depends(get_db)):
    """Reset password using reset token"""
    return auth_service.reset_password(db, payload)


@router.post(APIPaths.Auth.PREFIX + "/check-permission")
def check_permission(
    payload: PermissionCheckRequest,
    current_user: UserAccount = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Check if user has permission for resource and action"""
    result = auth_service.check_permission(db, current_user.user_id, payload.resource, payload.action)
    return {"data": result.model_dump(), "message": "Success", "error_code": None}

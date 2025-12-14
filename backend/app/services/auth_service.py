from __future__ import annotations

import hashlib
import os
import logging
from typing import Optional, BinaryIO

from sqlalchemy import insert, select
from sqlalchemy.orm import Session, selectinload
from fastapi import HTTPException, status

from app.models import UserAccount, UserProfile, SystemSetting
from app.schemas.auth import RegisterRequest, LoginRequest, ProfileUpdateRequest, AuthResponse, UserProfileResponse
from app.utils.file_handler import FileService
from app.core.config import settings
import jwt
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)


def _hash_password(plain: str) -> str:
    salt = os.urandom(8).hex()
    h = hashlib.sha256((salt + plain).encode("utf-8")).hexdigest()
    return f"{salt}${h}"


def _verify_password(stored: str, plain: str) -> bool:
    try:
        salt, h = stored.split("$", 1)
        return hashlib.sha256((salt + plain).encode("utf-8")).hexdigest() == h
    except Exception:
        return False


class AuthService:
    def __init__(self, file_service: Optional[FileService] = None):
        self.file_service = file_service or FileService()

    def register(self, db: Session, payload: RegisterRequest) -> dict:
        logger.info("Registering user %s", payload.username)
        with db.begin():
            hashed = _hash_password(payload.password)
            user = UserAccount(username=payload.username, password_hash=hashed, email=payload.email, status="ACTIVE")
            db.add(user)
            db.flush()

            profile = UserProfile(user_id=user.user_id)
            db.add(profile)

            # Insert default system settings in batch
            default_settings = [
                {"key_name": f"user:{user.user_id}:notify_email", "value": "true", "description": "Email notifications"},
                {"key_name": f"user:{user.user_id}:theme", "value": "light", "description": "UI Theme"},
                {"key_name": f"user:{user.user_id}:lang", "value": "vi-VN", "description": "Language"},
                {"key_name": f"user:{user.user_id}:timezone", "value": "UTC+7", "description": "Timezone"},
                {"key_name": f"user:{user.user_id}:chat_safety", "value": "standard", "description": "Chat safety level"},
            ]
            db.execute(insert(SystemSetting).values(default_settings))

        logger.info("User %s created (id=%s)", payload.username, user.user_id)
        return {"data": AuthResponse(user_id=user.user_id, username=user.username, email=user.email).model_dump(), "message": "Success", "error_code": None}

    def login(self, db: Session, payload: LoginRequest) -> dict:
        q = None
        if payload.username:
            q = select(UserAccount).where(UserAccount.username == payload.username)
        else:
            q = select(UserAccount).where(UserAccount.email == payload.email)
        user = db.execute(q).scalar_one_or_none()
        if user is None:
            logger.warning("Login failed: user not found")
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

        if not _verify_password(user.password_hash or "", payload.password):
            logger.warning("Login failed: wrong password for user %s", user.user_id)
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

        logger.info("User %s logged in", user.user_id)
        token = self._create_access_token(user.user_id)
        data = AuthResponse(user_id=user.user_id, username=user.username, email=user.email).model_dump()
        data["access_token"] = token
        return {"data": data, "message": "Success", "error_code": None}

    def _create_access_token(self, user_id: int) -> str:
        expire = datetime.utcnow() + timedelta(minutes=settings.access_token_expire_minutes)
        payload = {"sub": str(user_id), "exp": expire}
        token = jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)
        return token

    def update_profile(self, db: Session, user_id: int, payload: ProfileUpdateRequest, avatar_stream: Optional[BinaryIO] = None, avatar_filename: Optional[str] = None) -> dict:
        logger.info("Updating profile for user %s", user_id)
        # Defensive fetch with eager load
        stmt = select(UserAccount).options(selectinload(UserAccount.profile)).where(UserAccount.user_id == user_id)
        user = db.execute(stmt).scalar_one_or_none()
        if user is None:
            logger.error("User %s not found for profile update", user_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

        profile = user.profile
        if profile is None:
            logger.info("No profile found, creating for user %s", user_id)
            profile = UserProfile(user_id=user.user_id)

        saved_path = None
        try:
            with db.begin():
                if avatar_stream and avatar_filename:
                    saved_path = self.file_service.save_avatar(avatar_stream, avatar_filename)
                    profile.avatar_url = saved_path
                if payload.full_name is not None:
                    profile.full_name = payload.full_name
                if payload.bio is not None:
                    profile.bio = payload.bio
                db.add(profile)

        except Exception as e:
            logger.error("Profile update failed for user %s: %s", user_id, e, exc_info=True)
            # Compensating deletion of uploaded file if DB update failed
            if saved_path:
                try:
                    self.file_service.delete_file(saved_path)
                except Exception:
                    logger.exception("Failed to delete uploaded file during compensation")
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to update profile")

        logger.info("Profile updated for user %s", user_id)
        resp = UserProfileResponse(profile_id=profile.profile_id, user_id=profile.user_id, full_name=profile.full_name, bio=profile.bio, avatar_url=profile.avatar_url)
        return {"data": resp.model_dump(), "message": "Success", "error_code": None}

from __future__ import annotations

import hashlib
import os
import logging
import secrets
import smtplib
from typing import Optional, BinaryIO
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from sqlalchemy import insert, select
from sqlalchemy.orm import Session, selectinload
from fastapi import HTTPException, status

from app.models import UserAccount, UserProfile, SystemSetting
from app.schemas.auth import (RegisterRequest, LoginRequest, ProfileUpdateRequest, AuthResponse, 
                              UserProfileResponse, LoginResponse, TokenRefreshRequest, 
                              ChangePasswordRequest, ForgotPasswordRequest, ResetPasswordRequest,
                              UserDetailResponse, UserListResponse, PermissionCheckResponse)
from app.utils.file_handler import FileService
from app.core.config import settings
from datetime import datetime, timedelta
import logging


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
        
        # Store values before commit (session will expire attributes after commit)
        user_id = user.user_id
        username = user.username
        email = user.email
        
        db.commit()
        
        logger.info("User %s created (id=%s)", username, user_id)
        return {"data": AuthResponse(user_id=user_id, username=username, email=email).model_dump(), "message": "Success", "error_code": None}

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

        # Extract values before they might expire
        user_id = user.user_id
        username = user.username
        email = user.email
        password_hash = user.password_hash
        
        if not _verify_password(password_hash or "", payload.password):
            logger.warning("Login failed: wrong password for user %s", user_id)
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

        logger.info("User %s logged in", user_id)
        access_token = self._create_access_token(user_id)
        refresh_token = self._create_refresh_token(user_id)
        return {"data": LoginResponse(user_id=user_id, username=username, email=email, 
                                      access_token=access_token, refresh_token=refresh_token).model_dump(), 
                "message": "Success", "error_code": None}

    def _create_access_token(self, user_id: int) -> str:
        expire = datetime.utcnow() + timedelta(minutes=settings.access_token_expire_minutes)
        payload = {"sub": str(user_id), "exp": expire, "type": "access"}
        try:
            import jwt
            token = jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)
            return token
        except Exception:
            logging.getLogger(__name__).warning("PyJWT not available; returning placeholder token for user %s", user_id)
            return f"access-token-user-{user_id}"

    def _create_refresh_token(self, user_id: int) -> str:
        expire = datetime.utcnow() + timedelta(days=settings.refresh_token_expire_days)
        payload = {"sub": str(user_id), "exp": expire, "type": "refresh"}
        try:
            import jwt
            token = jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)
            return token
        except Exception:
            logging.getLogger(__name__).warning("PyJWT not available; returning placeholder refresh token for user %s", user_id)
            return f"refresh-token-user-{user_id}"

    def _create_password_reset_token(self, user_id: int) -> str:
        expire = datetime.utcnow() + timedelta(minutes=settings.password_reset_token_expire_minutes)
        payload = {"sub": str(user_id), "exp": expire, "type": "password_reset"}
        try:
            import jwt
            token = jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)
            return token
        except Exception:
            logging.getLogger(__name__).warning("PyJWT not available; returning placeholder reset token for user %s", user_id)
            return f"reset-token-user-{user_id}"

    def _verify_token(self, token: str, token_type: str = "access") -> Optional[int]:
        """Verify JWT token and return user_id if valid"""
        try:
            import jwt
            payload = jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
            if payload.get("type") != token_type:
                return None
            return int(payload.get("sub"))
        except Exception as e:
            logger.error("Token verification failed: %s", e)
            return None

    def refresh_token(self, payload: TokenRefreshRequest) -> dict:
        """Refresh access token using refresh token"""
        user_id = self._verify_token(payload.refresh_token, token_type="refresh")
        if user_id is None:
            logger.warning("Invalid refresh token")
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid refresh token")
        
        new_access_token = self._create_access_token(user_id)
        logger.info("Token refreshed for user %s", user_id)
        return {"data": {"access_token": new_access_token, "token_type": "bearer"}, 
                "message": "Success", "error_code": None}

    def get_user_profile(self, db: Session, user_id: int) -> dict:
        """Retrieve user profile information"""
        stmt = select(UserAccount).options(selectinload(UserAccount.profile)).where(UserAccount.user_id == user_id)
        user = db.execute(stmt).scalar_one_or_none()
        
        if user is None:
            logger.warning("User %s not found", user_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
        # Extract values to avoid lazy loading
        profile = user.profile
        profile_resp = UserProfileResponse(
            profile_id=profile.profile_id if profile else None,
            user_id=user.user_id,
            full_name=profile.full_name if profile else None,
            bio=profile.bio if profile else None,
            avatar_url=profile.avatar_url if profile else None
        ) if profile else None
        
        resp = UserDetailResponse(
            user_id=user.user_id,
            username=user.username,
            email=user.email,
            status=user.status,
            created_at=user.created_at,
            updated_at=user.updated_at,
            profile=profile_resp
        )
        logger.info("Retrieved profile for user %s", user_id)
        return {"data": resp.model_dump(), "message": "Success", "error_code": None}

    def get_users_list(self, db: Session, limit: int = 100, offset: int = 0) -> dict:
        """Retrieve list of users (admin only)"""
        stmt = select(UserAccount).limit(limit).offset(offset)
        users = db.execute(stmt).scalars().all()
        
        # Extract values to avoid lazy loading
        user_list = [
            UserListResponse(
                user_id=user.user_id,
                username=user.username,
                email=user.email,
                status=user.status,
                created_at=user.created_at
            ).model_dump()
            for user in users
        ]
        
        logger.info("Retrieved user list")
        return {"data": user_list, "message": "Success", "error_code": None}

    def change_password(self, db: Session, user_id: int, payload: ChangePasswordRequest) -> dict:
        """Change user password"""
        stmt = select(UserAccount).where(UserAccount.user_id == user_id)
        user = db.execute(stmt).scalar_one_or_none()
        
        if user is None:
            logger.warning("User %s not found for password change", user_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
        password_hash = user.password_hash
        if not _verify_password(password_hash or "", payload.old_password):
            logger.warning("Password change failed: incorrect old password for user %s", user_id)
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect old password")
        
        user.password_hash = _hash_password(payload.new_password)
        db.commit()
        
        logger.info("Password changed for user %s", user_id)
        return {"data": {"user_id": user_id}, "message": "Password changed successfully", "error_code": None}

    def forgot_password(self, db: Session, payload: ForgotPasswordRequest) -> dict:
        """Initiate forgot password flow"""
        user = db.execute(select(UserAccount).where(UserAccount.email == payload.email)).scalar_one_or_none()
        
        if user is None:
            # Return success even if user doesn't exist for security reasons
            logger.info("Forgot password request for non-existent email: %s", payload.email)
            return {"data": {}, "message": "If email exists, password reset link has been sent", "error_code": None}
        
        user_id = user.user_id
        email = user.email
        reset_token = self._create_password_reset_token(user_id)
        
        # Send email with reset link
        try:
            self._send_password_reset_email(email, reset_token)
            logger.info("Password reset email sent to user %s", user_id)
        except Exception as e:
            logger.error("Failed to send password reset email to user %s: %s", user_id, e)
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                              detail="Failed to send reset email")
        
        return {"data": {}, "message": "If email exists, password reset link has been sent", "error_code": None}

    def reset_password(self, db: Session, payload: ResetPasswordRequest) -> dict:
        """Reset password using reset token"""
        user_id = self._verify_token(payload.token, token_type="password_reset")
        if user_id is None:
            logger.warning("Invalid password reset token")
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired reset token")
        
        stmt = select(UserAccount).where(UserAccount.user_id == user_id)
        user = db.execute(stmt).scalar_one_or_none()
        
        if user is None:
            logger.warning("User %s not found for password reset", user_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        
        user.password_hash = _hash_password(payload.new_password)
        db.commit()
        
        logger.info("Password reset for user %s", user_id)
        return {"data": {}, "message": "Password reset successfully", "error_code": None}

    def check_permission(self, db: Session, user_id: int, resource: str, action: str) -> PermissionCheckResponse:
        """Check if user has permission for resource and action"""
        stmt = select(UserAccount).where(UserAccount.user_id == user_id)
        user = db.execute(stmt).scalar_one_or_none()
        
        if user is None:
            logger.warning("User %s not found for permission check", user_id)
            return PermissionCheckResponse(allowed=False, resource=resource, action=action, reason="User not found")
        
        # Basic permission logic - can be extended based on roles
        allowed = user.status == "ACTIVE"
        reason = None if allowed else "User is not active"
        
        logger.info("Permission check for user %s on %s:%s - %s", user_id, resource, action, "allowed" if allowed else "denied")
        return PermissionCheckResponse(allowed=allowed, resource=resource, action=action, reason=reason)

    def _send_password_reset_email(self, email: str, reset_token: str) -> None:
        """Send password reset email"""
        if not settings.smtp_user or not settings.smtp_password:
            logger.warning("SMTP credentials not configured, skipping email send")
            return
        
        try:
            msg = MIMEMultipart()
            msg['From'] = settings.email_from
            msg['To'] = email
            msg['Subject'] = "Password Reset Request"
            
            reset_link = f"http://localhost:8000/reset-password?token={reset_token}"
            body = f"""
            Hello,
            
            Click the link below to reset your password:
            {reset_link}
            
            This link will expire in {settings.password_reset_token_expire_minutes} minutes.
            
            If you did not request this, please ignore this email.
            
            Best regards,
            Thang Long University Support Team
            """
            
            msg.attach(MIMEText(body, 'plain'))
            
            with smtplib.SMTP(settings.smtp_server, settings.smtp_port) as server:
                server.starttls()
                server.login(settings.smtp_user, settings.smtp_password)
                server.send_message(msg)
            
            logger.info("Password reset email sent to %s", email)
        except Exception as e:
            logger.error("Failed to send email to %s: %s", email, e)
            raise

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
            if avatar_stream and avatar_filename:
                saved_path = self.file_service.save_avatar(avatar_stream, avatar_filename)
                profile.avatar_url = saved_path
            if payload.full_name is not None:
                profile.full_name = payload.full_name
            if payload.bio is not None:
                profile.bio = payload.bio
            db.add(profile)
            db.commit()

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

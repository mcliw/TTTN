from __future__ import annotations

import hashlib
import os
import logging
from typing import Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer
from starlette.requests import Request
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import get_db
from app.models import UserAccount
from sqlalchemy import select

logger = logging.getLogger(__name__)
security = HTTPBearer()


def get_password_hash(plain: str) -> str:
    """Return a salted SHA256 hash for the given plain-text password.

    This mirrors the simple hashing used elsewhere in the codebase to remain
    compatible with existing user records. For production consider using
    bcrypt or another well-tested KDF.
    """
    salt = os.urandom(8).hex()
    h = hashlib.sha256((salt + plain).encode("utf-8")).hexdigest()
    return f"{salt}${h}"


def verify_password(stored: str, plain: str) -> bool:
    try:
        salt, h = stored.split("$", 1)
        return hashlib.sha256((salt + plain).encode("utf-8")).hexdigest() == h
    except Exception:
        logger.exception("Password verification failed")
        return False


def _verify_jwt_token(token: str) -> Optional[int]:
    """Verify JWT token and return user_id if valid"""
    try:
        import jwt
        payload = jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
        if payload.get("type") != "access":
            return None
        return int(payload.get("sub"))
    except Exception as e:
        logger.error("Token verification failed: %s", e)
        return None


def get_current_user(
    credentials = Depends(security),
    db: Session = Depends(get_db)
) -> UserAccount:
    """
    Dependency to get current authenticated user from JWT token.
    
    Usage:
        @app.get("/me")
        def get_me(user: UserAccount = Depends(get_current_user)):
            return user
    """
    token = credentials.credentials
    user_id = _verify_jwt_token(token)
    
    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    # Fetch user from database
    user = db.execute(select(UserAccount).where(UserAccount.user_id == user_id)).scalar_one_or_none()
    
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    if user.status != "ACTIVE":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive"
        )
    
    return user


def get_current_admin_user(
    user: UserAccount = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> UserAccount:
    """
    Dependency to get current admin user.
    Only admin users can access endpoints using this dependency.
    
    Usage:
        @app.get("/users")
        def get_users(admin: UserAccount = Depends(get_current_admin_user)):
            return admin
    """
    # Check if user has admin role (customize based on your role system)
    # For now, we check if role_id corresponds to admin role (e.g., role_id = 1)
    if user.role_id != 1:  # Assuming role_id=1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    return user


def require_permission(resource: str, action: str):
    """
    Dependency factory to check user permissions for specific resource and action.
    
    Usage:
        @app.post("/chat/{chat_id}")
        def create_chat(
            chat_id: int,
            user: UserAccount = Depends(require_permission("chat", "create"))
        ):
            return chat_id
    """
    def check_permission(user: UserAccount = Depends(get_current_user)) -> UserAccount:
        # Customize permission logic based on your needs
        # For now, just check if user is active
        if user.status != "ACTIVE":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Permission denied for {resource}:{action}"
            )
        return user
    
    return check_permission

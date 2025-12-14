from __future__ import annotations

import logging
from typing import Optional
from sqlalchemy import insert, select
from sqlalchemy.orm import Session, selectinload

from app.models import UserAccount, UserProfile, SystemSetting

logger = logging.getLogger(__name__)


class UserRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_by_username_or_email(self, username: Optional[str] = None, email: Optional[str] = None) -> Optional[UserAccount]:
        if username:
            stmt = select(UserAccount).where(UserAccount.username == username).options(selectinload(UserAccount.profile))
        elif email:
            stmt = select(UserAccount).where(UserAccount.email == email).options(selectinload(UserAccount.profile))
        else:
            return None
        return self.db.execute(stmt).scalar_one_or_none()

    def create_user_with_profile_and_settings(self, username: str, password_hash: str, email: Optional[str] = None) -> UserAccount:
        logger.info("Creating user %s and default settings", username)
        user = UserAccount(username=username, password_hash=password_hash, email=email, status="ACTIVE")
        self.db.add(user)
        self.db.flush()

        profile = UserProfile(user_id=user.user_id)
        self.db.add(profile)

        default_settings = [
            {"key_name": f"user:{user.user_id}:notify_email", "value": "true", "description": "Email notifications"},
            {"key_name": f"user:{user.user_id}:theme", "value": "light", "description": "UI Theme"},
            {"key_name": f"user:{user.user_id}:lang", "value": "vi-VN", "description": "Language"},
            {"key_name": f"user:{user.user_id}:timezone", "value": "UTC+7", "description": "Timezone"},
            {"key_name": f"user:{user.user_id}:chat_safety", "value": "standard", "description": "Chat safety level"},
        ]
        self.db.execute(insert(SystemSetting).values(default_settings))
        return user

from __future__ import annotations

import logging
from typing import Optional, List
from sqlalchemy import select, func, update
from sqlalchemy.orm import Session, selectinload

from app.models import UserAccount, SystemErrorLog, SystemFeedback, WorkflowConfig, SystemSetting, ChatSession

logger = logging.getLogger(__name__)


class AdminRepository:
    def __init__(self, db: Session):
        self.db = db

    def count_total_users(self) -> int:
        """Count total users."""
        stmt = select(func.count()).select_from(UserAccount)
        return self.db.execute(stmt).scalar_one()

    def count_active_sessions_today(self) -> int:
        """Count active chat sessions created today."""
        from datetime import datetime, timedelta
        today = datetime.utcnow().date()
        stmt = select(func.count()).select_from(ChatSession).where(func.date(ChatSession.start_time) == today)
        return self.db.execute(stmt).scalar_one()

    def count_system_errors(self) -> int:
        """Count system errors."""
        stmt = select(func.count()).select_from(SystemErrorLog)
        return self.db.execute(stmt).scalar_one()

    def count_support_requests(self) -> int:
        """Count total support requests."""
        stmt = select(func.count()).select_from(SystemFeedback)
        return self.db.execute(stmt).scalar_one()

    def get_all_users(self, page: int = 1, size: int = 20) -> tuple[List[UserAccount], int]:
        """Get all users with pagination."""
        total_stmt = select(func.count()).select_from(UserAccount)
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(UserAccount)
            .order_by(UserAccount.created_at.desc())
            .options(selectinload(UserAccount.profile))
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().unique().all()
        return items, total

    def get_user_by_id(self, user_id: int) -> Optional[UserAccount]:
        """Get a specific user."""
        stmt = select(UserAccount).where(UserAccount.user_id == user_id).options(selectinload(UserAccount.profile))
        return self.db.execute(stmt).scalar_one_or_none()

    def update_user_status(self, user_id: int, status: str) -> Optional[UserAccount]:
        """Update user status (ban/activate)."""
        stmt = update(UserAccount).where(UserAccount.user_id == user_id).values(status=status)
        self.db.execute(stmt)
        return self.get_user_by_id(user_id)

    def update_user_role(self, user_id: int, role_id: int) -> Optional[UserAccount]:
        """Update user role."""
        stmt = update(UserAccount).where(UserAccount.user_id == user_id).values(role_id=role_id)
        self.db.execute(stmt)
        return self.get_user_by_id(user_id)

    def get_all_workflows(self, page: int = 1, size: int = 20) -> tuple[List[WorkflowConfig], int]:
        """Get all workflow configurations."""
        total_stmt = select(func.count()).select_from(WorkflowConfig)
        total = self.db.execute(total_stmt).scalar_one()

        stmt = (
            select(WorkflowConfig)
            .order_by(WorkflowConfig.created_at.desc())
            .options(selectinload(WorkflowConfig.creator))
            .limit(size)
            .offset((page - 1) * size)
        )
        items = self.db.execute(stmt).scalars().unique().all()
        return items, total

    def create_workflow(self, created_by: int, name: str, description: str, endpoint_url: str, auth_token: str, status: str) -> WorkflowConfig:
        """Create a new workflow configuration."""
        workflow = WorkflowConfig(
            created_by=created_by,
            workflow_name=name,
            description=description,
            endpoint_url=endpoint_url,
            auth_token=auth_token,
            status=status,
        )
        self.db.add(workflow)
        return workflow

    def update_workflow(self, workflow_id: int, **kwargs) -> Optional[WorkflowConfig]:
        """Update a workflow configuration."""
        stmt = update(WorkflowConfig).where(WorkflowConfig.workflow_id == workflow_id).values(**kwargs)
        self.db.execute(stmt)
        stmt_fetch = select(WorkflowConfig).where(WorkflowConfig.workflow_id == workflow_id)
        return self.db.execute(stmt_fetch).scalar_one_or_none()

    def delete_workflow(self, workflow_id: int) -> bool:
        """Delete a workflow configuration."""
        stmt = select(WorkflowConfig).where(WorkflowConfig.workflow_id == workflow_id)
        workflow = self.db.execute(stmt).scalar_one_or_none()
        if workflow:
            self.db.delete(workflow)
            return True
        return False

    def get_or_create_system_setting(self, key_name: str, default_value: str = "") -> SystemSetting:
        """Get or create a system setting."""
        stmt = select(SystemSetting).where(SystemSetting.key_name == key_name)
        setting = self.db.execute(stmt).scalar_one_or_none()
        if not setting:
            setting = SystemSetting(key_name=key_name, value=default_value)
            self.db.add(setting)
        return setting

    def update_system_setting(self, key_name: str, value: str, description: str = None) -> SystemSetting:
        """Update or create a system setting."""
        stmt = select(SystemSetting).where(SystemSetting.key_name == key_name)
        setting = self.db.execute(stmt).scalar_one_or_none()
        if setting:
            setting.value = value
            if description:
                setting.description = description
        else:
            setting = SystemSetting(key_name=key_name, value=value, description=description)
            self.db.add(setting)
        return setting

from __future__ import annotations

import logging
from typing import Dict, Any
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.repositories.admin_repo import AdminRepository
from app.schemas.admin import (
    DashboardStats,
    UserManagementResponse,
    UserListResponse,
    UserUpdateRequest,
    WorkflowConfigCreate,
    WorkflowConfigResponse,
    WorkflowConfigListResponse,
    SystemSettingUpdate,
)

logger = logging.getLogger(__name__)


class AdminService:
    def __init__(self, db: Session):
        self.repo = AdminRepository(db)
        self.db = db

    def get_dashboard_stats(self) -> Dict[str, Any]:
        """Get dashboard statistics (UC21, UC26)."""
        logger.info("Fetching dashboard statistics")
        total_users = self.repo.count_total_users()
        active_sessions = self.repo.count_active_sessions_today()
        error_count = self.repo.count_system_errors()
        support_requests = self.repo.count_support_requests()

        stats = DashboardStats(
            total_users=total_users,
            active_sessions_today=active_sessions,
            error_count=error_count,
            total_support_requests=support_requests,
        )
        return {
            "data": stats.model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def get_all_users(self, page: int = 1, size: int = 20) -> Dict[str, Any]:
        """Get all users with pagination (UC19)."""
        logger.info("Fetching all users (page=%s, size=%s)", page, size)
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination")

        items, total = self.repo.get_all_users(page=page, size=size)
        users = [
            UserManagementResponse(
                user_id=u.user_id,
                username=u.username,
                email=u.email,
                status=u.status,
                created_at=u.created_at,
            )
            for u in items
        ]
        return {
            "data": UserListResponse(items=users, total=total, page=page, size=size).model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def ban_user(self, user_id: int) -> Dict[str, Any]:
        """Ban a user (UC19)."""
        logger.info("Banning user %s", user_id)
        user = self.repo.update_user_status(user_id, "BANNED")
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

        return {
            "data": {"user_id": user.user_id, "status": user.status},
            "message": "User banned successfully",
            "error_code": None,
        }

    def unban_user(self, user_id: int) -> Dict[str, Any]:
        """Unban a user."""
        logger.info("Unbanning user %s", user_id)
        user = self.repo.update_user_status(user_id, "ACTIVE")
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

        return {
            "data": {"user_id": user.user_id, "status": user.status},
            "message": "User unbanned successfully",
            "error_code": None,
        }

    def assign_role(self, user_id: int, role_id: int) -> Dict[str, Any]:
        """Assign a role to a user (UC19)."""
        logger.info("Assigning role %s to user %s", role_id, user_id)
        user = self.repo.update_user_role(user_id, role_id)
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

        return {
            "data": {"user_id": user.user_id, "role_id": user.role_id},
            "message": "Role assigned successfully",
            "error_code": None,
        }

    def get_workflows(self, page: int = 1, size: int = 20) -> Dict[str, Any]:
        """Get all workflow configurations (UC22)."""
        logger.info("Fetching workflows (page=%s, size=%s)", page, size)
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination")

        items, total = self.repo.get_all_workflows(page=page, size=size)
        workflows = [
            WorkflowConfigResponse(
                workflow_id=w.workflow_id,
                workflow_name=w.workflow_name,
                description=w.description,
                endpoint_url=w.endpoint_url,
                status=w.status,
                created_at=w.created_at,
            )
            for w in items
        ]
        return {
            "data": WorkflowConfigListResponse(items=workflows, total=total, page=page, size=size).model_dump(),
            "message": "Success",
            "error_code": None,
        }

    def create_workflow(self, admin_id: int, payload: WorkflowConfigCreate) -> Dict[str, Any]:
        """Create a workflow configuration (UC22)."""
        logger.info("Admin %s creating workflow %s", admin_id, payload.workflow_name)
        with self.db.begin():
            workflow = self.repo.create_workflow(
                created_by=admin_id,
                name=payload.workflow_name,
                description=payload.description,
                endpoint_url=payload.endpoint_url,
                auth_token=payload.auth_token or "",
                status=payload.status,
            )

        return {
            "data": {
                "workflow_id": workflow.workflow_id,
                "workflow_name": workflow.workflow_name,
                "status": workflow.status,
            },
            "message": "Workflow created successfully",
            "error_code": None,
        }

    def update_workflow(self, workflow_id: int, payload: WorkflowConfigCreate) -> Dict[str, Any]:
        """Update a workflow configuration (UC22)."""
        logger.info("Updating workflow %s", workflow_id)
        with self.db.begin():
            updated = self.repo.update_workflow(
                workflow_id,
                workflow_name=payload.workflow_name,
                description=payload.description,
                endpoint_url=payload.endpoint_url,
                auth_token=payload.auth_token or "",
                status=payload.status,
            )
            if not updated:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Workflow not found")

        return {
            "data": {
                "workflow_id": updated.workflow_id,
                "workflow_name": updated.workflow_name,
                "status": updated.status,
            },
            "message": "Workflow updated successfully",
            "error_code": None,
        }

    def delete_workflow(self, workflow_id: int) -> Dict[str, Any]:
        """Delete a workflow configuration (UC22)."""
        logger.info("Deleting workflow %s", workflow_id)
        with self.db.begin():
            success = self.repo.delete_workflow(workflow_id)
            if not success:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Workflow not found")

        return {
            "data": {"workflow_id": workflow_id, "deleted": True},
            "message": "Workflow deleted successfully",
            "error_code": None,
        }

    def update_system_setting(self, payload: SystemSettingUpdate) -> Dict[str, Any]:
        """Update a system setting (UC24)."""
        logger.info("Updating system setting %s", payload.key_name)
        with self.db.begin():
            setting = self.repo.update_system_setting(
                key_name=payload.key_name,
                value=payload.value,
                description=payload.description,
            )

        return {
            "data": {
                "setting_id": setting.setting_id,
                "key_name": setting.key_name,
                "value": setting.value,
            },
            "message": "Setting updated successfully",
            "error_code": None,
        }

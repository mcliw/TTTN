from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.api_paths import APIPaths
from app.services.admin_service import AdminService
from app.schemas.admin import WorkflowConfigCreate, SystemSettingUpdate

router = APIRouter(prefix=APIPaths.Admin.PREFIX, tags=["v1-admin"])
logger = logging.getLogger(__name__)


@router.get(APIPaths.Admin.DASHBOARD_STATS)
def get_dashboard(db: Session = Depends(get_db)):
    """Get dashboard statistics (UC21, UC26)."""
    service = AdminService(db)
    return service.get_dashboard_stats()


@router.get(APIPaths.Admin.LIST_USERS)
def list_users(page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get all users with pagination (UC19)."""
    service = AdminService(db)
    return service.get_all_users(page=page, size=size)


@router.post(APIPaths.Admin.BAN_USER)
def ban_user(user_id: int, db: Session = Depends(get_db)):
    """Ban a user (UC19)."""
    service = AdminService(db)
    return service.ban_user(user_id)


@router.post(APIPaths.Admin.UNBAN_USER)
def unban_user(user_id: int, db: Session = Depends(get_db)):
    """Unban a user."""
    service = AdminService(db)
    return service.unban_user(user_id)


@router.post(APIPaths.Admin.ASSIGN_ROLE)
def assign_user_role(user_id: int, role_id: int = Query(...), db: Session = Depends(get_db)):
    """Assign a role to a user (UC19)."""
    service = AdminService(db)
    return service.assign_role(user_id, role_id)


@router.get(APIPaths.Admin.LIST_WORKFLOWS)
def list_workflows(page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get workflow configurations (UC22)."""
    service = AdminService(db)
    return service.get_workflows(page=page, size=size)


@router.post(APIPaths.Admin.CREATE_WORKFLOW)
def create_workflow(payload: WorkflowConfigCreate, admin_id: int = Query(...), db: Session = Depends(get_db)):
    """Create a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.create_workflow(admin_id, payload)


@router.put(APIPaths.Admin.UPDATE_WORKFLOW)
def update_workflow(workflow_id: int, payload: WorkflowConfigCreate, db: Session = Depends(get_db)):
    """Update a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.update_workflow(workflow_id, payload)


@router.delete(APIPaths.Admin.DELETE_WORKFLOW)
def delete_workflow(workflow_id: int, db: Session = Depends(get_db)):
    """Delete a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.delete_workflow(workflow_id)


@router.put(APIPaths.Admin.UPDATE_SETTING)
def update_setting(payload: SystemSettingUpdate, db: Session = Depends(get_db)):
    """Update a system setting (UC24)."""
    service = AdminService(db)
    return service.update_system_setting(payload)

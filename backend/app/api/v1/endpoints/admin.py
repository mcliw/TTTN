from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.admin_service import AdminService
from app.schemas.admin import WorkflowConfigCreate, SystemSettingUpdate

router = APIRouter(prefix="/v1/admin", tags=["v1-admin"])
logger = logging.getLogger(__name__)


@router.get("/dashboard/stats")
def get_dashboard(db: Session = Depends(get_db)):
    """Get dashboard statistics (UC21, UC26)."""
    service = AdminService(db)
    return service.get_dashboard_stats()


@router.get("/users")
def list_users(page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get all users with pagination (UC19)."""
    service = AdminService(db)
    return service.get_all_users(page=page, size=size)


@router.post("/users/{user_id}/ban")
def ban_user(user_id: int, db: Session = Depends(get_db)):
    """Ban a user (UC19)."""
    service = AdminService(db)
    return service.ban_user(user_id)


@router.post("/users/{user_id}/unban")
def unban_user(user_id: int, db: Session = Depends(get_db)):
    """Unban a user."""
    service = AdminService(db)
    return service.unban_user(user_id)


@router.post("/users/{user_id}/assign-role")
def assign_user_role(user_id: int, role_id: int = Query(...), db: Session = Depends(get_db)):
    """Assign a role to a user (UC19)."""
    service = AdminService(db)
    return service.assign_role(user_id, role_id)


@router.get("/workflows")
def list_workflows(page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    """Get workflow configurations (UC22)."""
    service = AdminService(db)
    return service.get_workflows(page=page, size=size)


@router.post("/workflows")
def create_workflow(payload: WorkflowConfigCreate, admin_id: int = Query(...), db: Session = Depends(get_db)):
    """Create a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.create_workflow(admin_id, payload)


@router.put("/workflows/{workflow_id}")
def update_workflow(workflow_id: int, payload: WorkflowConfigCreate, db: Session = Depends(get_db)):
    """Update a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.update_workflow(workflow_id, payload)


@router.delete("/workflows/{workflow_id}")
def delete_workflow(workflow_id: int, db: Session = Depends(get_db)):
    """Delete a workflow configuration (UC22)."""
    service = AdminService(db)
    return service.delete_workflow(workflow_id)


@router.put("/settings")
def update_setting(payload: SystemSettingUpdate, db: Session = Depends(get_db)):
    """Update a system setting (UC24)."""
    service = AdminService(db)
    return service.update_system_setting(payload)

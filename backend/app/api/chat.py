from __future__ import annotations

import logging
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.schemas.auth import ChatMessageCreate
from app.services.chat_service import ChatService

router = APIRouter(prefix="/chat", tags=["chat"])
logger = logging.getLogger(__name__)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


chat_service = ChatService()


@router.post("/message")
def post_message(payload: ChatMessageCreate, db: Session = Depends(get_db)):
    return chat_service.process_message(db, payload)


@router.get("/{session_id}/history")
def get_history(session_id: int, page: int = Query(1, ge=1), size: int = Query(20, ge=1, le=100), db: Session = Depends(get_db)):
    return chat_service.fetch_history(db, session_id, page=page, size=size)

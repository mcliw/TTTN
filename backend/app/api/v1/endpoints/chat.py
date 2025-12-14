from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.chat_service import ChatService
from app.schemas.auth import ChatMessageCreate

router = APIRouter(prefix="/v1/chat", tags=["v1-chat"])
chat_service = ChatService()


@router.post("/message")
def post_message(payload: ChatMessageCreate, db: Session = Depends(get_db)):
    return chat_service.process_message(db, payload)


@router.get("/{session_id}/history")
def get_history(session_id: int, page: int = 1, size: int = 20, db: Session = Depends(get_db)):
    return chat_service.fetch_history(db, session_id, page=page, size=size)

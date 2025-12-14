from __future__ import annotations

import logging
from typing import Dict, Any, List, Tuple

from sqlalchemy import select, func
from sqlalchemy.orm import Session, selectinload
from fastapi import HTTPException, status

from app.models import ChatSession, ChatMessage
from app.schemas.auth import ChatMessageCreate, ChatMessagePayload, PaginatedMessages
from app.n8n.webhook_service import trigger_webhook
from app.ai.intent_classifier import classify_intent
from app.core.database import SessionLocal
import threading

logger = logging.getLogger(__name__)


class ChatService:
    def __init__(self):
        pass

    def process_message(self, db: Session, payload: ChatMessageCreate) -> dict:
        logger.info("Processing message for session %s by user %s", payload.session_id, payload.user_id)

        # Defensive: check session exists and belongs to user
        stmt = select(ChatSession).options(selectinload(ChatSession.messages)).where(ChatSession.session_id == payload.session_id)
        session_obj = db.execute(stmt).scalar_one_or_none()
        if session_obj is None:
            logger.error("ChatSession %s not found", payload.session_id)
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
        if session_obj.user_id != payload.user_id:
            logger.error("User %s is not owner of session %s", payload.user_id, payload.session_id)
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not allowed")

        # Start transaction: insert message as PENDING
        with db.begin():
            msg = ChatMessage(session_id=payload.session_id, sender_type="user", content=payload.message_content, status="PENDING")
            db.add(msg)
            db.flush()

            # Build history (last 20 messages including this one)
            messages = sorted(session_obj.messages + [msg], key=lambda m: getattr(m, "created_at", None) or 0)
            history = []
            for m in messages[-20:]:
                history.append({"sender": m.sender_type, "content": m.content, "status": m.status})

            payload_obj = ChatMessagePayload(query=payload.message_content, history=history)

            # Update message status to PROCESSING
            msg.status = "PROCESSING"
            db.add(msg)

        logger.info("Message %s queued for processing", msg.message_id)

        # Fire-and-forget: trigger webhook and process result in background thread
        def _background_process(message_id: int, session_id: int, text: str):
            try:
                intent = classify_intent(text)
                payload = {"query": text, "history": history, "intent": intent}
                res = trigger_webhook("/mock/n8n", payload)
                # Save a bot message based on webhook response
                db2 = SessionLocal()
                try:
                    with db2.begin():
                        bot_text = f"n8n_queued:{res.get('run_id') or 'unknown'}"
                        bot_msg = ChatMessage(session_id=session_id, sender_type="bot", content=bot_text, status="DONE")
                        db2.add(bot_msg)
                finally:
                    db2.close()
            except Exception:
                logger.exception("Background processing failed for message %s", message_id)

        threading.Thread(target=_background_process, args=(msg.message_id, payload.session_id, payload.message_content), daemon=True).start()

        return {"data": payload_obj.model_dump(), "message": "Success", "error_code": None}

    def fetch_history(self, db: Session, session_id: int, page: int = 1, size: int = 20) -> dict:
        if page < 1 or size < 1:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid pagination parameters")

        total_q = select(func.count()).select_from(ChatMessage).where(ChatMessage.session_id == session_id)
        total = db.execute(total_q).scalar_one()

        q = select(ChatMessage).where(ChatMessage.session_id == session_id).order_by(ChatMessage.created_at.desc()).limit(size).offset((page - 1) * size)
        items = [
            {"message_id": m.message_id, "sender": m.sender_type, "content": m.content, "status": m.status, "created_at": m.created_at}
            for m in db.execute(q).scalars().all()
        ]

        paginated = PaginatedMessages(items=items, total=total, page=page, size=size)
        return {"data": paginated.model_dump(), "message": "Success", "error_code": None}

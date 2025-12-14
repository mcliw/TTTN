from __future__ import annotations

import logging
from typing import Dict

logger = logging.getLogger(__name__)


def classify_intent(text: str) -> Dict[str, float]:
    """Mock intent classifier that returns a dominant intent and score."""
    text = (text or "").lower()
    if "grade" in text or "score" in text:
        intent = "grade_lookup"
    elif "schedule" in text or "timetable" in text:
        intent = "schedule_lookup"
    else:
        intent = "general_chat"
    logger.debug("Classified intent %s for text: %s", intent, text)
    return {"intent": intent, "score": 0.9}

from __future__ import annotations

import logging
from typing import Dict, Any

logger = logging.getLogger(__name__)


def trigger_webhook(url: str, payload: Dict[str, Any]) -> Dict[str, Any]:
    """Mock an n8n webhook trigger. In real system, this would POST to n8n."""
    logger.info("Triggering webhook %s with payload keys: %s", url, list(payload.keys()))
    # Simulate a response
    return {"status": "ok", "run_id": "mock-run-123"}

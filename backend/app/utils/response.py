from __future__ import annotations
from typing import Any, Optional

def success(data: Any = None, message: str = "Success") -> dict:
    return {"data": data, "message": message, "error_code": None}


def error(message: str, error_code: Optional[str] = "error") -> dict:
    return {"data": None, "message": message, "error_code": error_code}

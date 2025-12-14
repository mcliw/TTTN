from __future__ import annotations

import hashlib
import os
import logging

logger = logging.getLogger(__name__)


def get_password_hash(plain: str) -> str:
    """Return a salted SHA256 hash for the given plain-text password.

    This mirrors the simple hashing used elsewhere in the codebase to remain
    compatible with existing user records. For production consider using
    bcrypt or another well-tested KDF.
    """
    salt = os.urandom(8).hex()
    h = hashlib.sha256((salt + plain).encode("utf-8")).hexdigest()
    return f"{salt}${h}"


def verify_password(stored: str, plain: str) -> bool:
    try:
        salt, h = stored.split("$", 1)
        return hashlib.sha256((salt + plain).encode("utf-8")).hexdigest() == h
    except Exception:
        logger.exception("Password verification failed")
        return False

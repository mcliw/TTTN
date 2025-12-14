from __future__ import annotations

import os
import uuid
import logging
from typing import BinaryIO
from app.core.config import settings

logger = logging.getLogger(__name__)


class FileService:
    """Utility service that writes files to local disk and can delete them.

    This is intentionally minimal; in production this would be an S3/remote client.
    """

    def __init__(self, base_dir: str | None = None):
        self.base_dir = base_dir or settings.upload_dir
        os.makedirs(self.base_dir, exist_ok=True)

    def save_avatar(self, stream: BinaryIO, original_filename: str) -> str:
        """Save an avatar file and return a relative file path."""
        ext = os.path.splitext(original_filename)[1]
        fname = f"avatar-{uuid.uuid4().hex}{ext}"
        out_path = os.path.join(self.base_dir, "avatars")
        os.makedirs(out_path, exist_ok=True)
        full_path = os.path.join(out_path, fname)
        try:
            with open(full_path, "wb") as fh:
                data = stream.read()
                fh.write(data)
            logger.info("Saved avatar to %s", full_path)
            return full_path
        except Exception as e:
            logger.error("Failed to save avatar: %s", e, exc_info=True)
            # On failure, try to remove partial file
            try:
                if os.path.exists(full_path):
                    os.remove(full_path)
            except Exception:
                pass
            raise

    def delete_file(self, path: str) -> None:
        try:
            if os.path.exists(path):
                os.remove(path)
                logger.info("Deleted file %s", path)
        except Exception as e:
            logger.error("Failed to delete file %s: %s", path, e, exc_info=True)

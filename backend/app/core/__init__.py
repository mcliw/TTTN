# Core configuration package
# Keep legacy `get_settings` API but delegate to `config.Settings` implementation
from .config import settings as _settings


def get_settings():
    return _settings


__all__ = ["get_settings"]

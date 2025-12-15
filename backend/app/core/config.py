from __future__ import annotations

import logging
import os
from typing import Optional
from dotenv import load_dotenv

load_dotenv()


class Settings:
    # App
    environment: str = os.getenv("ENVIRONMENT", "development")
    dev_mode: bool = os.getenv("DEV_MODE", "true").lower() in ("1", "true", "yes")
    host: str = os.getenv("HOST", "0.0.0.0")
    port: int = int(os.getenv("PORT", "8000"))
    log_level: str = os.getenv("LOG_LEVEL", "INFO")

    # Database
    # Accept a SQLAlchemy style URL, or a JDBC style URL and convert it.
    _raw_db = os.getenv("DATABASE_URL")
    if _raw_db and _raw_db.startswith("jdbc:postgresql://"):
        import re

        m = re.match(r"jdbc:postgresql://([^:/]+)(?::(\d+))?/([^?]+)", _raw_db)
        if m:
            _host = m.group(1)
            _port = m.group(2) or "5432"
            _name = m.group(3)
        else:
            _host, _port, _name = ("localhost", "5432", "main_tlu")
        _user = os.getenv("DATABASE_USER", os.getenv("DB_USERNAME", "postgres"))
        _pw = os.getenv("DATABASE_PASSWORD", os.getenv("DB_PASSWORD", ""))
        # SQLAlchemy + psycopg (psycopg v3) URL
        database_url: Optional[str] = f"postgresql+psycopg://{_user}:{_pw}@{_host}:{_port}/{_name}"
    else:
        # Default to using psycopg (psycopg v3) dialect. Use DATABASE_URL env to override.
        database_url: Optional[str] = os.getenv("DATABASE_URL", "postgresql+psycopg://postgres:DEADlift12Hard@localhost:5432/main_tlu")

    # Chroma
    chroma_persist_dir: Optional[str] = os.getenv("CHROMA_PERSIST_DIR", "./chroma_data")

    # AI
    openai_api_key: Optional[str] = os.getenv("OPENAI_API_KEY")

    # n8n
    n8n_url: Optional[str] = os.getenv("N8N_URL")
    n8n_api_key: Optional[str] = os.getenv("N8N_API_KEY")

    # Security / Auth
    jwt_secret: str = os.getenv("JWT_SECRET", "change-me-in-prod")
    jwt_algorithm: str = os.getenv("JWT_ALGORITHM", "HS256")
    access_token_expire_minutes: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))
    refresh_token_expire_days: int = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "7"))
    password_reset_token_expire_minutes: int = int(os.getenv("PASSWORD_RESET_TOKEN_EXPIRE_MINUTES", "30"))
    smtp_server: Optional[str] = os.getenv("SMTP_SERVER", "smtp.gmail.com")
    smtp_port: int = int(os.getenv("SMTP_PORT", "587"))
    smtp_user: Optional[str] = os.getenv("SMTP_USER")
    smtp_password: Optional[str] = os.getenv("SMTP_PASSWORD")
    email_from: Optional[str] = os.getenv("EMAIL_FROM", "noreply@thanglong.edu.vn")

    # File uploads
    upload_dir: str = os.getenv("UPLOAD_DIR", "uploads")


def configure_logging():
    cfg = Settings()
    level = logging.getLevelName(cfg.log_level)
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
    )


settings = Settings()

from __future__ import annotations

import logging
from sqlalchemy import create_engine, text
from sqlalchemy.exc import NoSuchModuleError
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

from app.core.config import settings
from app.models.base import Base

logger = logging.getLogger(__name__)


# Create SQLAlchemy engine and session factory.
# Use pool_pre_ping to avoid stale connections and allow echo in dev mode.
# Keep sqlite connect_args only for sqlite URLs to avoid passing unsupported args to Postgres.
_connect_args = {"check_same_thread": False} if settings.database_url and settings.database_url.startswith("sqlite:") else {}

engine = None
SessionLocal = None
try:
    engine = create_engine(
        settings.database_url,
        echo=settings.dev_mode,
        pool_pre_ping=True,
        future=True,
        connect_args=_connect_args,
    )
    SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
except NoSuchModuleError as exc:
    # SQLAlchemy reports this when the DB driver/dialect is missing (e.g. psycopg)
    logger.exception("Database driver/dialect not available: %s", exc)
    logger.error("Missing DB driver for URL %s. Install psycopg[binary] and retry.", settings.database_url)
    engine = None
    SessionLocal = None
except ModuleNotFoundError as exc:
    logger.exception("Python DB driver not installed: %s", exc)
    logger.error("Missing Python DB driver. Install psycopg[binary] and retry.")
    engine = None
    SessionLocal = None
except Exception as exc:
    logger.exception("Failed to create DB engine: %s", exc)
    engine = None
    SessionLocal = None


def create_tables() -> None:
    """Create all tables using SQLAlchemy models. Suitable for development use.

    Note: We use create_all() in development for simplicity; in production prefer
    explicit migrations with Alembic (not automatic create_all).
    """
    if engine is None:
        logger.warning("Skipping create_tables(): DB engine is not configured")
        return
    logger.info("Creating database tables (if not exist)")
    Base.metadata.create_all(bind=engine)


def test_connection(timeout_seconds: int = 5) -> bool:
    """Run a lightweight test query (SELECT 1) to verify DB connectivity."""
    if engine is None:
        logger.warning("Database engine not available for test_connection")
        return False
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        logger.info("Database connectivity verified (SELECT 1)")
        return True
    except SQLAlchemyError as exc:
        logger.exception("Database connectivity test failed: %s", exc)
        return False


def get_db():
    """FastAPI dependency that yields a DB `Session` and ensures it is closed."""
    if SessionLocal is None:
        raise RuntimeError("Database session factory is not configured")
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


from contextlib import contextmanager


@contextmanager
def begin_session():
    """Context manager that yields a session already inside a transaction.

    Usage:
        with begin_session() as db:
            db.add(...)
    """
    if SessionLocal is None:
        raise RuntimeError("Database session factory is not configured")
    db = SessionLocal()
    try:
        with db.begin():
            yield db
    finally:
        db.close()

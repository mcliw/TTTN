from fastapi import APIRouter

router = APIRouter(prefix="/api")


@router.get("/health")
def health():
    # Lightweight checks: DB connectivity (SELECT 1)
    db_ready = False
    try:
        from app.core.database import test_connection

        db_ready = test_connection()
    except Exception:
        db_ready = False

    status = "ok" if db_ready else "degraded"
    return {"status": status, "database_ready": db_ready}

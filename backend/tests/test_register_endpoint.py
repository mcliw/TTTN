import sys
import os

# Ensure project root in path when running tests directly
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from fastapi.testclient import TestClient
from app.main import app
from app.core.database import get_db
from app.models.base import Base
from sqlalchemy import create_engine
from sqlalchemy.pool import StaticPool
from sqlalchemy.orm import sessionmaker

# Create a temporary in-memory SQLite DB for testing
engine = create_engine(
    "sqlite:///:memory:",
    future=True,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
# Create all tables needed for registration and login flow
from app.models import (UserAccount, UserProfile, UserRole, SystemSetting, 
                        SystemNotification, UserOAuthIdentity, ChatSession, 
                        SystemFeedback, WorkflowConfig)
UserAccount.__table__.create(bind=engine)
UserProfile.__table__.create(bind=engine)
UserRole.__table__.create(bind=engine)
SystemSetting.__table__.create(bind=engine)
UserOAuthIdentity.__table__.create(bind=engine)
SystemNotification.__table__.create(bind=engine)
ChatSession.__table__.create(bind=engine)
SystemFeedback.__table__.create(bind=engine)
WorkflowConfig.__table__.create(bind=engine)


def get_test_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = get_test_db


def test_register_endpoint():
    client = TestClient(app)
    payload = {"username": "sinhvien_moi", "password": "Password123!", "email": "sv_moi@thanglong.edu.vn"}
    resp = client.post("/api/v1/auth/register", json=payload)
    print('status', resp.status_code)
    print('body', resp.json())
    assert resp.status_code in (200, 201)
    assert resp.json().get("data") is not None
    
    # Test login with the newly created user
    login_payload = {"username": "sinhvien_moi", "password": "Password123!"}
    login_resp = client.post("/api/v1/auth/login", json=login_payload)
    print('login status', login_resp.status_code)
    print('login body', login_resp.json())
    assert login_resp.status_code == 200
    assert login_resp.json().get("data") is not None
    assert login_resp.json()["data"].get("access_token") is not None


if __name__ == '__main__':
    test_register_endpoint()


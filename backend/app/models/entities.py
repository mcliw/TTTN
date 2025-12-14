# Deprecated: models split into per-table modules.
# Keep this file temporarily for backward compatibility.
from . import *  # noqa: F401,F403


class UserAccount(Base):
    __tablename__ = "user_account"

    user_id = Column(Integer, primary_key=True, index=True)
    role_id = Column(Integer, index=True)
    username = Column(String(150), nullable=False)
    password_hash = Column(String(512))
    email = Column(String(255), index=True)
    auth_type = Column(String(50))
    external_auth = Column(Boolean, default=False)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    oauth_identities = relationship(
        "UserOAuthIdentity",
        primaryjoin="UserAccount.user_id==UserOAuthIdentity.user_id",
        back_populates="user",
        lazy="selectin",
    )
    profile = relationship(
        "UserProfile",
        primaryjoin="UserAccount.user_id==UserProfile.user_id",
        back_populates="user",
        uselist=False,
        lazy="selectin",
    )
    sessions = relationship(
        "ChatSession",
        primaryjoin="UserAccount.user_id==ChatSession.user_id",
        back_populates="user",
        lazy="selectin",
    )
    feedbacks = relationship(
        "SystemFeedback",
        primaryjoin="UserAccount.user_id==SystemFeedback.user_id",
        back_populates="user",
        lazy="selectin",
    )
    notifications = relationship(
        "SystemNotification",
        primaryjoin="UserAccount.user_id==SystemNotification.receiver_id",
        back_populates="receiver",
        lazy="selectin",
    )
    workflows = relationship(
        "WorkflowConfig",
        primaryjoin="UserAccount.user_id==WorkflowConfig.created_by",
        back_populates="creator",
        lazy="selectin",
    )


class UserOAuthIdentity(Base):
    __tablename__ = "user_oauth_identity"

    oauth_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    provider = Column(String(50))
    provider_user_id = Column(String(255), index=True)
    email = Column(String(255), index=True)
    access_token = Column(Text)
    refresh_token = Column(Text)
    token_expired_at = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship(
        "UserAccount",
        primaryjoin="UserOAuthIdentity.user_id==UserAccount.user_id",
        back_populates="oauth_identities",
        lazy="selectin",
    )


class UserRole(Base):
    __tablename__ = "user_role"

    role_id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(150))
    description = Column(Text)


class UserProfile(Base):
    __tablename__ = "user_profile"

    profile_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    department_id = Column(Integer, index=True)
    full_name = Column(String(255))
    phone = Column(String(50))
    avatar_url = Column(String(1024))
    position = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship(
        "UserAccount",
        primaryjoin="UserProfile.user_id==UserAccount.user_id",
        back_populates="profile",
        lazy="selectin",
        uselist=False,
    )


class ChatSession(Base):
    __tablename__ = "chat_session"

    session_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    start_time = Column(DateTime, default=datetime.utcnow)
    end_time = Column(DateTime)
    total_messages = Column(Integer, default=0)
    status = Column(String(50))

    user = relationship(
        "UserAccount",
        primaryjoin="ChatSession.user_id==UserAccount.user_id",
        back_populates="sessions",
        lazy="selectin",
    )
    messages = relationship(
        "ChatMessage",
        primaryjoin="ChatSession.session_id==ChatMessage.session_id",
        back_populates="session",
        lazy="selectin",
    )


class ChatMessage(Base):
    __tablename__ = "chat_message"

    message_id = Column(Integer, primary_key=True, index=True)
    session_id = Column(Integer, index=True)
    intent_id = Column(Integer, index=True)
    sender_type = Column(String(50))
    content = Column(Text)
    entity_detected = Column(JSONB)
    created_at = Column(DateTime, default=datetime.utcnow)
    status = Column(String(50))

    session = relationship(
        "ChatSession",
        primaryjoin="ChatMessage.session_id==ChatSession.session_id",
        back_populates="messages",
        lazy="selectin",
    )
    intent = relationship(
        "ChatIntent",
        primaryjoin="ChatMessage.intent_id==ChatIntent.intent_id",
        back_populates="messages",
        lazy="selectin",
    )


class ChatIntent(Base):
    __tablename__ = "chat_intent"

    intent_id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, index=True)
    model_id = Column(Integer, index=True)
    intent_name = Column(String(255))
    description = Column(Text)
    example_phrases = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    messages = relationship(
        "ChatMessage",
        primaryjoin="ChatIntent.intent_id==ChatMessage.intent_id",
        back_populates="intent",
        lazy="selectin",
    )
    entities = relationship(
        "ChatEntity",
        primaryjoin="ChatIntent.intent_id==ChatEntity.intent_id",
        back_populates="intent",
        lazy="selectin",
    )


class ChatEntity(Base):
    __tablename__ = "chat_entity"

    entity_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    entity_name = Column(String(255))
    entity_type = Column(String(100))
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    intent = relationship(
        "ChatIntent",
        primaryjoin="ChatEntity.intent_id==ChatIntent.intent_id",
        back_populates="entities",
        lazy="selectin",
    )


class ChatHistoryAnalysis(Base):
    __tablename__ = "chat_history_analysis"

    analysis_id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, index=True)
    intent_id = Column(Integer, index=True)
    confidence_score = Column(Float)
    entities_json = Column(JSONB)
    processing_time = Column(Float)
    model_used = Column(String(255))
    analyzed_at = Column(DateTime, default=datetime.utcnow)


class AIModelConfig(Base):
    __tablename__ = "ai_model_config"

    model_id = Column(Integer, primary_key=True, index=True)
    model_name = Column(String(255))
    provider = Column(String(255))
    api_key = Column(String(1024))
    temperature = Column(Float)
    max_tokens = Column(Integer)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)


class AITrainingDataset(Base):
    __tablename__ = "ai_training_dataset"

    data_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    input_text = Column(Text)
    label = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)


class SystemResponseTemplate(Base):
    __tablename__ = "system_response_template"

    template_id = Column(Integer, primary_key=True, index=True)
    entity_id = Column(Integer, index=True)
    template_type = Column(String(100))
    content = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)


class WorkflowConfig(Base):
    __tablename__ = "workflow_config"

    workflow_id = Column(Integer, primary_key=True, index=True)
    created_by = Column(Integer, index=True)
    workflow_name = Column(String(255))
    description = Column(Text)
    endpoint_url = Column(String(1024))
    auth_token = Column(String(1024))
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

    creator = relationship(
        "UserAccount",
        primaryjoin="WorkflowConfig.created_by==UserAccount.user_id",
        back_populates="workflows",
        lazy="selectin",
        uselist=False,
    )
    executions = relationship(
        "WorkflowExecutionLog",
        primaryjoin="WorkflowConfig.workflow_id==WorkflowExecutionLog.workflow_id",
        back_populates="workflow",
        lazy="selectin",
    )


class WorkflowExecutionLog(Base):
    __tablename__ = "workflow_execution_log"

    exec_id = Column(Integer, primary_key=True, index=True)
    workflow_id = Column(Integer, index=True)
    user_id = Column(Integer, index=True)
    input_data = Column(JSONB)
    output_data = Column(JSONB)
    status = Column(String(50))
    executed_at = Column(DateTime, default=datetime.utcnow)
    duration_ms = Column(Integer)

    workflow = relationship(
        "WorkflowConfig",
        primaryjoin="WorkflowExecutionLog.workflow_id==WorkflowConfig.workflow_id",
        back_populates="executions",
        lazy="selectin",
    )
    errors = relationship(
        "SystemErrorLog",
        primaryjoin="WorkflowExecutionLog.exec_id==SystemErrorLog.exec_id",
        back_populates="execution",
        lazy="selectin",
    )


class WorkflowMapping(Base):
    __tablename__ = "workflow_mapping"

    mapping_id = Column(Integer, primary_key=True, index=True)
    intent_id = Column(Integer, index=True)
    workflow_id = Column(Integer, index=True)
    active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)


class SystemErrorLog(Base):
    __tablename__ = "system_error_log"

    error_id = Column(Integer, primary_key=True, index=True)
    exec_id = Column(Integer, index=True)
    source = Column(String(255))
    message = Column(Text)
    stack_trace = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    execution = relationship(
        "WorkflowExecutionLog",
        primaryjoin="SystemErrorLog.exec_id==WorkflowExecutionLog.exec_id",
        back_populates="errors",
        lazy="selectin",
        uselist=False,
    )


class SystemFeedback(Base):
    __tablename__ = "system_feedback"

    feedback_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    session_id = Column(Integer, index=True)
    rating = Column(Integer)
    comment = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship(
        "UserAccount",
        primaryjoin="SystemFeedback.user_id==UserAccount.user_id",
        back_populates="feedbacks",
        lazy="selectin",
        uselist=False,
    )
    session = relationship(
        "ChatSession",
        primaryjoin="SystemFeedback.session_id==ChatSession.session_id",
        lazy="selectin",
        uselist=False,
    )


class SystemNotification(Base):
    __tablename__ = "system_notification"

    notification_id = Column(Integer, primary_key=True, index=True)
    receiver_id = Column(Integer, index=True)
    title = Column(String(255))
    message = Column(Text)
    status = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)

    receiver = relationship(
        "UserAccount",
        primaryjoin="SystemNotification.receiver_id==UserAccount.user_id",
        back_populates="notifications",
        lazy="selectin",
        uselist=False,
    )


class CommonTaskCategory(Base):
    __tablename__ = "common_task_category"

    category_id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String(255))
    description = Column(Text)


class CommonDepartment(Base):
    __tablename__ = "common_department"

    department_id = Column(Integer, primary_key=True, index=True)
    department_name = Column(String(255))
    description = Column(Text)


class CommonStatus(Base):
    __tablename__ = "common_status"

    status_id = Column(Integer, primary_key=True, index=True)
    status_code = Column(String(100))
    description = Column(Text)


class SystemSetting(Base):
    __tablename__ = "system_setting"

    setting_id = Column(Integer, primary_key=True, index=True)
    key_name = Column(String(255), index=True)
    value = Column(Text)
    description = Column(Text)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class AIVectorIndex(Base):
    __tablename__ = "ai_vector_index"

    vector_id = Column(Integer, primary_key=True, index=True)
    source_table = Column(String(255), index=True)
    source_record_id = Column(Integer, index=True)
    embedding_model = Column(String(255))
    chunk_index = Column(Integer)
    content_hash = Column(String(255), index=True)
    created_at = Column(DateTime, default=datetime.utcnow)


# Additional explicit indexes (where beneficial)
Index("ix_user_oauth_provider_user", UserOAuthIdentity.provider_user_id)

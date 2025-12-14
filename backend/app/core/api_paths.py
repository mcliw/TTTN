"""
Central Route Management - Single Source of Truth for all API paths.

This module defines all URL paths used in the application in a hierarchical
structure to ensure consistency and prevent duplication.
"""

from __future__ import annotations


class APIPaths:
    """Root API paths configuration."""

    PREFIX_V1 = "/api/v1"

    class Auth:
        """Authentication endpoints."""

        PREFIX = "/auth"
        REGISTER = "/register"
        LOGIN = "/login"
        PROFILE = "/profile"
        PROFILE_BY_ID = "/profile/{user_id}"

    class Chat:
        """Chat/Messaging endpoints."""

        PREFIX = "/chat"
        SEND_MESSAGE = "/message"
        HISTORY = "/{session_id}/history"

    class Academic:
        """Academic information endpoints."""

        PREFIX = "/academic"
        STUDENT_GRADES = "/grades/{student_id}"
        STUDENT_SCHEDULE = "/schedule/{student_id}"
        SUBJECTS = "/subjects"
        SUBJECTS_SEARCH = "/subjects/search"
        NOTIFICATIONS = "/notifications/{user_id}"

    class Support:
        """Support/Advisor endpoints."""

        PREFIX = "/support"
        SUBMIT_REQUEST = "/request"
        STUDENT_REQUESTS = "/requests/{student_id}"
        ADVISOR_STUDENTS = "/advisor/{advisor_id}/students"
        STUDENT_PROFILE = "/student/{student_id}/profile"
        REPLY = "/reply"

    class Admin:
        """Admin management endpoints."""

        PREFIX = "/admin"
        DASHBOARD_STATS = "/dashboard/stats"
        LIST_USERS = "/users"
        BAN_USER = "/users/{user_id}/ban"
        UNBAN_USER = "/users/{user_id}/unban"
        ASSIGN_ROLE = "/users/{user_id}/assign-role"
        LIST_WORKFLOWS = "/workflows"
        CREATE_WORKFLOW = "/workflows"
        UPDATE_WORKFLOW = "/workflows/{workflow_id}"
        DELETE_WORKFLOW = "/workflows/{workflow_id}"
        UPDATE_SETTING = "/settings"


# For convenience, export the full paths if needed elsewhere
FULL_PATHS = {
    "auth_register": f"{APIPaths.PREFIX_V1}{APIPaths.Auth.PREFIX}{APIPaths.Auth.REGISTER}",
    "auth_login": f"{APIPaths.PREFIX_V1}{APIPaths.Auth.PREFIX}{APIPaths.Auth.LOGIN}",
    "auth_profile": f"{APIPaths.PREFIX_V1}{APIPaths.Auth.PREFIX}{APIPaths.Auth.PROFILE_BY_ID}",
    "chat_message": f"{APIPaths.PREFIX_V1}{APIPaths.Chat.PREFIX}{APIPaths.Chat.SEND_MESSAGE}",
    "chat_history": f"{APIPaths.PREFIX_V1}{APIPaths.Chat.PREFIX}{APIPaths.Chat.HISTORY}",
    "academic_grades": f"{APIPaths.PREFIX_V1}{APIPaths.Academic.PREFIX}{APIPaths.Academic.STUDENT_GRADES}",
    "academic_schedule": f"{APIPaths.PREFIX_V1}{APIPaths.Academic.PREFIX}{APIPaths.Academic.STUDENT_SCHEDULE}",
    "academic_subjects": f"{APIPaths.PREFIX_V1}{APIPaths.Academic.PREFIX}{APIPaths.Academic.SUBJECTS}",
    "academic_subjects_search": f"{APIPaths.PREFIX_V1}{APIPaths.Academic.PREFIX}{APIPaths.Academic.SUBJECTS_SEARCH}",
    "academic_notifications": f"{APIPaths.PREFIX_V1}{APIPaths.Academic.PREFIX}{APIPaths.Academic.NOTIFICATIONS}",
    "support_request": f"{APIPaths.PREFIX_V1}{APIPaths.Support.PREFIX}{APIPaths.Support.SUBMIT_REQUEST}",
    "support_student_requests": f"{APIPaths.PREFIX_V1}{APIPaths.Support.PREFIX}{APIPaths.Support.STUDENT_REQUESTS}",
    "support_advisor_students": f"{APIPaths.PREFIX_V1}{APIPaths.Support.PREFIX}{APIPaths.Support.ADVISOR_STUDENTS}",
    "support_student_profile": f"{APIPaths.PREFIX_V1}{APIPaths.Support.PREFIX}{APIPaths.Support.STUDENT_PROFILE}",
    "support_reply": f"{APIPaths.PREFIX_V1}{APIPaths.Support.PREFIX}{APIPaths.Support.REPLY}",
    "admin_dashboard": f"{APIPaths.PREFIX_V1}{APIPaths.Admin.PREFIX}{APIPaths.Admin.DASHBOARD_STATS}",
    "admin_users": f"{APIPaths.PREFIX_V1}{APIPaths.Admin.PREFIX}{APIPaths.Admin.LIST_USERS}",
}

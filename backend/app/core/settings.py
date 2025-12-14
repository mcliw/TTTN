try:
    from pydantic import BaseSettings
except Exception:
    from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "Chatbot TLU Backend"
    debug: bool = True


def get_settings() -> Settings:
    return Settings()

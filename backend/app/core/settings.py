from pydantic import BaseSettings


class Settings(BaseSettings):
    app_name: str = "Chatbot TLU Backend"
    debug: bool = True


def get_settings() -> Settings:
    return Settings()

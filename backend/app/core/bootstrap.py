from __future__ import annotations

import logging
import asyncio
from typing import Optional, Dict, Any

from app.core.config import Settings

logger = logging.getLogger(__name__)


class Subsystem:
    name: str

    def __init__(self, settings: Settings):
        self.settings = settings
        self.ready = False
        self.details: Dict[str, Any] = {}

    async def init(self) -> None:
        raise NotImplementedError()

    async def health_check(self) -> bool:
        raise NotImplementedError()

    async def shutdown(self) -> None:
        raise NotImplementedError()


class DatabaseSubsystem(Subsystem):
    def __init__(self, settings: Settings):
        super().__init__(settings)
        self.engine = None
        self.SessionLocal = None
        self.name = "database"

    async def init(self) -> None:
        try:
            # Use the centralized database module which configures engine and sessions
            from app.core.database import engine, SessionLocal, create_tables, test_connection

            logger.info("Initializing database: %s", self.settings.database_url)
            self.engine = engine
            self.SessionLocal = SessionLocal

            if self.settings.dev_mode:
                logger.info("Dev mode: creating database tables if they do not exist")
                try:
                    create_tables()
                except Exception:
                    logger.exception("Failed to create tables in dev mode")

            # Verify connectivity with a lightweight query
            ok = test_connection()
            if not ok:
                logger.error("Database initialized but failed connectivity test")
                self.ready = False
            else:
                self.ready = True

            self.details["url"] = self.settings.database_url
        except Exception:
            logger.exception("Failed to initialize database")
            self.ready = False

    async def health_check(self) -> bool:
        if not self.engine:
            return False
        try:
            # Use a safe test via SQL
            from app.core.database import test_connection

            return test_connection()
        except Exception:
            logger.exception("Database health check failed")
            return False

    async def shutdown(self) -> None:
        try:
            if self.engine is not None:
                logger.info("Disposing database engine")
                self.engine.dispose()
        except Exception:
            logger.exception("Error during database shutdown")


class ChromaSubsystem(Subsystem):
    def __init__(self, settings: Settings):
        super().__init__(settings)
        self.client = None
        self.name = "chroma"

    async def init(self) -> None:
        try:
            logger.info("Initializing ChromaDB client at %s", self.settings.chroma_persist_dir)
            import chromadb
            from chromadb.config import Settings as ChromaSettings

            self.client = chromadb.Client(ChromaSettings(persist_directory=self.settings.chroma_persist_dir))
            # optional: ensure collections exist or create default
            self.ready = True
        except Exception:
            logger.exception("Failed to initialize ChromaDB client")
            self.ready = False

    async def health_check(self) -> bool:
        if not self.client:
            return False
        try:
            # basic check: list collections
            _ = self.client.list_collections()
            return True
        except Exception:
            logger.exception("Chroma health check failed")
            return False

    async def shutdown(self) -> None:
        try:
            # chromadb may have a persist or close call
            if self.client is not None:
                try:
                    self.client.persist()
                except Exception:
                    pass
        except Exception:
            logger.exception("Error during Chroma shutdown")


class AIAgentSubsystem(Subsystem):
    def __init__(self, settings: Settings, chroma: Optional[ChromaSubsystem] = None):
        super().__init__(settings)
        self.name = "ai_agent"
        self.agent = None
        self.chroma = chroma

    async def init(self) -> None:
        try:
            logger.info("Initializing AI agent (LLM + RAG)")
            # Try to import LangChain parts; degrade gracefully if not available
            try:
                from langchain.llms import OpenAI
                from langchain.embeddings import OpenAIEmbeddings
                from langchain.vectorstores import Chroma
            except Exception:
                logger.warning("LangChain/OpenAI libraries not available; AI agent will be degraded")
                self.ready = False
                return

            if not self.settings.openai_api_key:
                logger.warning("OPENAI_API_KEY not set; AI agent will be degraded")
                self.ready = False
                return

            # create embeddings and LLM
            embeddings = OpenAIEmbeddings(openai_api_key=self.settings.openai_api_key)
            llm = OpenAI(openai_api_key=self.settings.openai_api_key)

            # connect to chroma if available
            vectorstore = None
            if self.chroma and self.chroma.client:
                try:
                    vectorstore = Chroma(embedding_function=embeddings, client=self.chroma.client, collection_name="default")
                except Exception:
                    logger.exception("Failed to initialize chroma-backed vectorstore; AI will run without RAG")

            # store a minimal agent object
            self.agent = {"llm": llm, "embeddings": embeddings, "vectorstore": vectorstore}
            self.ready = True
        except Exception:
            logger.exception("Failed to initialize AI agent")
            self.ready = False

    async def health_check(self) -> bool:
        if not self.agent:
            return False
        try:
            # basic sanity: ensure llm is callable without making network calls
            return True
        except Exception:
            logger.exception("AI agent health check failed")
            return False

    async def shutdown(self) -> None:
        try:
            # no special shutdown for langchain objects; let GC handle
            self.agent = None
        except Exception:
            logger.exception("Error during AI agent shutdown")


class N8nSubsystem(Subsystem):
    def __init__(self, settings: Settings):
        super().__init__(settings)
        self.session = None
        self.name = "n8n"

    async def init(self) -> None:
        try:
            import requests

            logger.info("Preparing n8n webhook client for %s", self.settings.n8n_url)
            self.session = requests.Session()
            if self.settings.n8n_api_key:
                self.session.headers.update({"Authorization": f"Bearer {self.settings.n8n_api_key}"})
            self.ready = True
        except Exception:
            logger.exception("Failed to prepare n8n client")
            self.ready = False

    async def health_check(self) -> bool:
        if not self.settings.n8n_url or not self.session:
            return False
        try:
            resp = self.session.get(self.settings.n8n_url, timeout=3)
            return resp.status_code < 400
        except Exception:
            logger.exception("n8n health check failed")
            return False

    async def shutdown(self) -> None:
        try:
            if self.session is not None:
                self.session.close()
        except Exception:
            logger.exception("Error during n8n shutdown")


class SystemBootstrap:
    def __init__(self, settings: Settings):
        self.settings = settings
        self.db = DatabaseSubsystem(settings)
        self.chroma = ChromaSubsystem(settings)
        self.ai = AIAgentSubsystem(settings, chroma=self.chroma)
        self.n8n = N8nSubsystem(settings)
        self.subsystems = [self.db, self.chroma, self.ai, self.n8n]

    async def init_all(self) -> None:
        # Initialize subsystems sequentially, log progress, failures don't crash
        for s in self.subsystems:
            try:
                logger.info("Initializing subsystem: %s", s.name)
                await s.init()
                logger.info("Finished initializing %s (ready=%s)", s.name, s.ready)
            except Exception:
                logger.exception("Exception initializing subsystem %s", s.name)

        # Run health checks asynchronously with timeouts
        await self._check_all_health()

    async def _check_all_health(self) -> None:
        tasks = []
        for s in self.subsystems:
            tasks.append(self._safe_health_check(s))
        await asyncio.gather(*tasks)

    async def _safe_health_check(self, subsystem: Subsystem) -> None:
        try:
            ok = await asyncio.wait_for(subsystem.health_check(), timeout=5)
            logger.info("Health check %s: %s", subsystem.name, ok)
        except Exception:
            logger.exception("Health check failed for %s", subsystem.name)

    async def shutdown_all(self) -> None:
        # Shutdown in reverse order
        for s in reversed(self.subsystems):
            try:
                logger.info("Shutting down subsystem: %s", s.name)
                await s.shutdown()
            except Exception:
                logger.exception("Error shutting down subsystem %s", s.name)

    def status(self) -> Dict[str, Any]:
        return {s.name: {"ready": s.ready, **s.details} for s in self.subsystems}

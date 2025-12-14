import logging
import sys
import os

# Ensure project root is on sys.path so running `python main.py` works
_PACKAGE_DIR = os.path.dirname(os.path.abspath(__file__))
_PROJECT_ROOT = os.path.dirname(_PACKAGE_DIR)
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from fastapi import FastAPI
from fastapi import Request
from contextlib import asynccontextmanager
from fastapi.responses import JSONResponse

from app.core.config import settings, configure_logging
from app.core.bootstrap import SystemBootstrap
from importlib import import_module
import pkgutil

configure_logging()
logger = logging.getLogger(__name__)


def create_app(lifespan=None) -> FastAPI:
    app = FastAPI(title="Chatbot TLU Backend", lifespan=lifespan)

    # Register routers dynamically from app.api package
    try:
        import app.api as api_pkg
        for finder, name, ispkg in pkgutil.iter_modules(api_pkg.__path__):
            module_name = f"app.api.{name}"
            try:
                mod = import_module(module_name)
                router = getattr(mod, "router", None)
                if router is not None:
                    app.include_router(router)
                    logger.debug("Included router from %s", module_name)
            except Exception:
                logger.exception("Failed to include router %s", module_name)
    except Exception:
        logger.exception("Failed to scan app.api package for routers")

    @app.get("/")
    def root():
        return {"message": "Chatbot TLU backend"}

    @app.exception_handler(Exception)
    async def _handle_exceptions(request: Request, exc: Exception):
        logger.exception("Unhandled exception: %s", exc)
        return JSONResponse(status_code=500, content={"detail": "Internal Server Error"})

    return app


# Create a bootstrap instance that will manage subsystem lifecycle
bootstrap = SystemBootstrap(settings=settings)


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting system bootstrap...")
    try:
        await bootstrap.init_all()
        logger.info("System bootstrap completed. Status: %s", bootstrap.status())
    except Exception:
        logger.exception("Bootstrap init failed")
    try:
        yield
    finally:
        logger.info("Shutting down subsystems...")
        try:
            await bootstrap.shutdown_all()
            logger.info("Shutdown complete")
        except Exception:
            logger.exception("Shutdown failed")


app = create_app(lifespan=lifespan)


def _run_uvicorn():
    import uvicorn

    reload = settings.dev_mode
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=reload,
        log_level=settings.log_level.lower(),
    )


if __name__ == "__main__":
    try:
        _run_uvicorn()
    except Exception:
        logger.exception("Failed to start server")
        sys.exit(1)

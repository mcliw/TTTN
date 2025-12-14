from fastapi import APIRouter
from importlib import import_module
import pkgutil
import logging

from app.core.api_paths import APIPaths

logger = logging.getLogger(__name__)

router = APIRouter(prefix=APIPaths.PREFIX_V1)

# Dynamically include endpoint modules under app.api.v1.endpoints
try:
    import app.api.v1.endpoints as endpoints_pkg
    for finder, name, ispkg in pkgutil.iter_modules(endpoints_pkg.__path__):
        module_name = f"app.api.v1.endpoints.{name}"
        try:
            mod = import_module(module_name)
            sub_router = getattr(mod, "router", None)
            if sub_router is not None:
                router.include_router(sub_router)
                logger.debug("Included v1 endpoint %s", module_name)
        except Exception:
            logger.exception("Failed to include v1 endpoint %s", module_name)
except Exception:
    logger.exception("Failed to scan v1 endpoints")

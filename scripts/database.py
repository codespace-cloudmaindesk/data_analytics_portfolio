import os
from sqlalchemy import create_engine
from scripts.config import DATABASE_URL, logger

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    connect_args={"sslmode": os.getenv("DB_SSLMODE", "prefer")}
)
logger.info(f"Database engine initialized")
from sqlalchemy import create_engine
from scripts.config import DATABASE_URL

engine = create_engine(DATABASE_URL)
from sqlalchemy import text
from scripts.database import engine
from pathlib import Path

SQL_DIR = Path("sql")


def run_sql_file(relative_path: str):
    file_path = SQL_DIR / relative_path

    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    with engine.begin() as conn:
        conn.execute(text(sql))
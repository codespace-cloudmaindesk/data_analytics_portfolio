import re
from pathlib import Path

from sqlalchemy import text

from scripts.config import DATA_DIR
from scripts.database import engine

SQL_DIR = Path("sql")

COPY_PATTERN = re.compile(
    r"COPY\s+(.*?)\s+FROM\s+'([^']+)'\s+WITH\s*(\([^)]+\))",
    re.IGNORECASE | re.DOTALL,
)


def run_sql_file(relative_path: str):

    file_path = SQL_DIR / relative_path

    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    statements = [s.strip() for s in sql.split(";") if s.strip()]

    with engine.begin() as conn:

        for statement in statements:

            match = COPY_PATTERN.search(statement)

            if match:
                table_info, csv_path, options = match.groups()

                csv_file = DATA_DIR / csv_path.replace("/data/", "")

                copy_sql = (
                    f"COPY {table_info} "
                    f"FROM STDIN WITH {options}"
                )

                raw_conn = conn.connection.driver_connection

                with open(csv_file, "r", encoding="utf-8") as f:
                    with raw_conn.cursor() as cur:
                        cur.copy_expert(copy_sql, f)

            else:
                conn.execute(text(statement))
import re
import sqlparse
from pathlib import Path
from typing import List, Tuple, Optional
from sqlalchemy import text

from scripts.config import DATA_DIR
from scripts.database import engine


SQL_DIR = Path("sql")

COPY_PATTERN = re.compile(
    r"COPY\s+(.*?)\s+FROM\s+'([^']+)'\s+WITH\s*(\([^)]+\))",
    re.IGNORECASE | re.DOTALL,
)

def load_sql_file(relative_path: str) -> str:
    file_path = SQL_DIR / relative_path

    if not file_path.exists():
        raise FileNotFoundError(f"SQL file not found: {file_path}")

    return file_path.read_text(encoding="utf-8")


def split_statements(sql: str) -> List[str]:
    return [str(stmt).strip() for stmt in sqlparse.split(sql) if str(stmt).strip()]

def parse_copy_statement(statement: str) -> Optional[Tuple[str, str, str]]:
    match = COPY_PATTERN.search(statement)
    if not match:
        return None
    return match.groups()


def resolve_csv_path(csv_path: str) -> Path:
    if not csv_path.startswith("/data/"):
        raise ValueError(f"Expected CSV path to start with '/data/', got: {csv_path}")
    cleaned = csv_path[len("/data/"):]
    return DATA_DIR / cleaned


def execute_copy(conn, table_info: str, csv_path: str, options: str) -> None:
    csv_file = resolve_csv_path(csv_path)

    if not csv_file.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_file}")

    copy_sql = f"COPY {table_info} FROM STDIN WITH {options}"

    raw_conn = conn.connection.driver_connection

    with csv_file.open("r", encoding="utf-8") as f:
        with raw_conn.cursor() as cur:
            cur.copy_expert(copy_sql, f)


def execute_statement(conn, statement: str) -> None:
    conn.execute(text(statement))

def run_sql_file(relative_path: str) -> None:
    sql = load_sql_file(relative_path)
    statements = split_statements(sql)

    with engine.begin() as conn:
        for statement in statements:

            copy_data = parse_copy_statement(statement)

            if copy_data:
                table_info, csv_path, options = copy_data
                execute_copy(conn, table_info, csv_path, options)
            else:
                execute_statement(conn, statement)
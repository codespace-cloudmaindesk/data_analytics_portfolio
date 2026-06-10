from pathlib import Path
import re

from sqlalchemy import text

from scripts.database import engine
from scripts.export_csv import export_gold_to_csv
from scripts.config import DATA_DIR, logger

SQL_DIR = Path("sql")


def run_sql_file(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    # Split SQL content into individual statements
    statements = sql.split(";")

    with engine.begin() as conn:
        for statement in statements:
            stmt = statement.strip()
            if not stmt:
                continue

            # Check if it is a COPY statement
            if re.search(r"\bCOPY\b", stmt, re.IGNORECASE):
                match = re.search(r"FROM\s+'([^']+)'", stmt, re.IGNORECASE)
                if match:
                    file_path_str = match.group(1)
                    if file_path_str.startswith("/data/"):
                        rel_path = file_path_str[6:]
                    else:
                        rel_path = file_path_str.lstrip("/")

                    local_file_path = DATA_DIR / rel_path

                    # Convert COPY FROM '/path' to COPY FROM STDIN
                    copy_sql = re.sub(r"FROM\s+'[^']+'", "FROM STDIN", stmt, flags=re.IGNORECASE)

                    logger.info(f"Loading local CSV {local_file_path} to DB using copy_expert")

                    # Get DBAPI connection for copy_expert
                    raw_conn = None
                    if hasattr(conn.connection, "dbapi_connection"):
                        raw_conn = conn.connection.dbapi_connection
                    elif hasattr(conn.connection, "driver_connection"):
                        raw_conn = conn.connection.driver_connection
                    else:
                        raw_conn = conn.connection

                    with raw_conn.cursor() as cur:
                        with open(local_file_path, "r", encoding="utf-8") as csv_file:
                            cur.copy_expert(copy_sql, csv_file)
                    continue

            # Execute other statements normally
            conn.execute(text(stmt))


def run_pipeline():

    files = [

        "setup/01_create_schemas.sql",

        "bronze/02_create_tables.sql",
        "bronze/03_load_cust_info.sql",
        "bronze/04_load_prd_info.sql",
        "bronze/05_load_sales_info.sql",
        "bronze/06_load_geo_info.sql",

        "silver/01_crm_cust.sql",
        "silver/02_erp_cust.sql",
        "silver/03_erp_loc.sql",
        "silver/04_erp_prd.sql",
        "silver/05_crm_prd.sql",
        "silver/06_crm_sales.sql",

        "gold/01_dim_customers.sql",
        "gold/02_dim_product.sql",
        "gold/03_fact_sales.sql",
        "gold/04_reporting_mart.sql"
    ]

    for file in files:
        print(f"Running {file}")
        run_sql_file(SQL_DIR / file)

    print("Pipeline Complete")
    export_gold_to_csv()


if __name__ == "__main__":
    run_pipeline()
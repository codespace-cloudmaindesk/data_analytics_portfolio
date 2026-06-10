import pandas as pd
from sqlalchemy import text
from scripts.database import engine


def run_query(query: str):
    with engine.connect() as conn:
        return pd.read_sql(text(query), conn)


def get_reporting_mart():
    return run_query("SELECT * FROM gold.reporting_mart")


def get_fact_sales():
    return run_query("SELECT * FROM gold.fact_sales")


def get_dim_customer():
    return run_query("SELECT * FROM gold.dim_customer")


def get_dim_product():
    return run_query("SELECT * FROM gold.dim_product")
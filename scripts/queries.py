import pandas as pd
from sqlalchemy import text

from scripts.database import engine


def get_reporting_mart():

    query = """
    SELECT *
    FROM gold.reporting_mart
    """

    with engine.connect() as conn:
        return pd.read_sql(text(query), conn)


def get_fact_sales():

    query = """
    SELECT *
    FROM gold.fact_sales
    """

    with engine.connect() as conn:
        return pd.read_sql(text(query), conn)


def get_dim_customer():

    query = """
    SELECT *
    FROM gold.dim_customer
    """

    with engine.connect() as conn:
        return pd.read_sql(text(query), conn)


def get_dim_product():

    query = """
    SELECT *
    FROM gold.dim_product
    """

    with engine.connect() as conn:
        return pd.read_sql(text(query), conn)
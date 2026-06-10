import pandas as pd

from scripts.database import engine


def get_reporting_mart():

    query = """
    SELECT *
    FROM gold.reporting_mart
    """

    return pd.read_sql(query, engine)


def get_fact_sales():

    query = """
    SELECT *
    FROM gold.fact_sales
    """

    return pd.read_sql(query, engine)


def get_dim_customer():

    query = """
    SELECT *
    FROM gold.dim_customer
    """

    return pd.read_sql(query, engine)


def get_dim_product():

    query = """
    SELECT *
    FROM gold.dim_product
    """

    return pd.read_sql(query, engine)
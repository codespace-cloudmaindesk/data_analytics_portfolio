import pandas as pd
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parent.parent / "data"

def get_reporting_mart():
    return pd.read_csv(DATA_DIR / "reporting_mart.csv")

def get_fact_sales():
    return pd.read_csv(DATA_DIR / "fact_sales.csv")

def get_dim_customer():
    return pd.read_csv(DATA_DIR / "dim_customers.csv")

def get_dim_product():
    return pd.read_csv(DATA_DIR / "dim_product.csv")
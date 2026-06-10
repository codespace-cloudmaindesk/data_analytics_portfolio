import sys
from pathlib import Path
import streamlit as st
import pandas as pd

ROOT_DIR = Path(__file__).resolve().parents[2]
DATA_FILE = ROOT_DIR / "data" / "reporting_mart.csv"

@st.cache_data
def load_data():
    if not DATA_FILE.exists():
        st.error(f"File not found: {DATA_FILE}")
        return pd.DataFrame()
    return pd.read_csv(DATA_FILE)

df = load_data()

st.title("Executive Overview")

total_revenue = df["sales_amount"].sum()
total_orders = df["order_number"].nunique()
total_customers = df["customer_id"].nunique()

col1, col2, col3 = st.columns(3)

with col1:
    st.metric("Revenue", f"R{total_revenue:,.0f}")

with col2:
    st.metric("Total Orders", f"{total_orders:,}")

with col3:
    st.metric("Customers", f"{total_customers:,}")

st.dataframe(df.head())
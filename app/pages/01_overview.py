import sys
from pathlib import Path
import streamlit as st
import pandas as pd

ROOT_DIR = Path(__file__).resolve().parents[2]
DATA_FILE = ROOT_DIR / "data" / "reporting_mart.csv"

@st.cache_data
def load_data():
    if not DATA_FILE.exists():
        return pd.DataFrame()
    try:
        return pd.read_csv(DATA_FILE)
    except Exception as e:
        st.error(f"Error loading data: {e}")
        return pd.DataFrame()

df = load_data()

st.title("Executive Overview")

if df.empty:
    st.warning("⚠️ Data file not found or empty. Please run the data pipeline to generate the reporting mart CSV file.")
    st.info("To generate the data, run: `run_pipeline.sh` (or `python scripts/pipeline.py` and `python scripts/export_csv.py`) and verify that `data/reporting_mart.csv` is populated.")
else:
    # Check if necessary columns exist
    required_cols = ["sales_amount", "order_number", "customer_id"]
    missing_cols = [col for col in required_cols if col not in df.columns]
    if missing_cols:
        st.error(f"Missing required columns in dataset: {missing_cols}")
    else:
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

        st.markdown("### Sample Data")
        st.dataframe(df.head())
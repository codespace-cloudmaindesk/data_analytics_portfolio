import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent.parent))

import streamlit as st
from scripts.queries import get_reporting_mart


@st.cache_data
def load_data():
    return get_reporting_mart()

df = load_data()

st.title("Executive Overview")

total_revenue = df["sales_amount"].sum()
total_orders = df["order_number"].nunique()
total_customers = df["customer_id"].nunique()

col1, col2, col3 = st.columns(3)

col1.metric(
    "Revenue",
    f"R{total_revenue:,.0f}"
)

col2.metric(
    "Orders",
    f"{total_orders:,}"
)

col3.metric(
    "Customers",
    f"{total_customers:,}"
)

st.dataframe(df.head(5))

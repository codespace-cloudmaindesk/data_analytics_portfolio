import streamlit as st
import pandas as pd
from scripts.queries import get_reporting_mart


@st.cache_data(ttl=300)
def load_data():
    try:
        df = get_reporting_mart()

        required_cols = {"price", "order_number", "customer_id"}

        if not required_cols.issubset(df.columns):
            st.error(f"Missing required columns: {required_cols - set(df.columns)}")
            return pd.DataFrame()

        return df

    except Exception as e:
        st.error(f"Error loading data: {e}")
        return pd.DataFrame()


df = load_data()

st.title("Executive Overview")

if df.empty:
    st.warning("No data available. Run pipeline or check gold.reporting_mart view.")
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
    st.dataframe(df.head(), width="stretch")
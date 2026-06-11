import os
import sys

# Add project root to sys.path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import pandas as pd
import streamlit as st

from scripts.queries import get_reporting_mart
from scripts.transformation import (
    calculate_kpis,
    monthly_sales,
    category_sales,
    country_sales,
)

from components.metrics import render_kpis
from components.filters import render_filters
from components.charts import (
    revenue_trend,
    category_chart,
    country_chart,
)


@st.cache_data(ttl=300)
def load_data():

    try:
        return get_reporting_mart()

    except Exception as e:
        st.error(f"Error loading data: {e}")
        return pd.DataFrame()


st.title("Executive Overview")

df = load_data()

if df.empty:
    st.warning("No data available.")
    st.stop()

filtered_df = render_filters(df)

kpis = calculate_kpis(filtered_df)

render_kpis(kpis)

st.divider()

revenue_trend(
    monthly_sales(filtered_df)
)

col1, col2 = st.columns(2)

with col1:
    category_chart(
        category_sales(filtered_df)
    )

with col2:
    country_chart(
        country_sales(filtered_df)
    )
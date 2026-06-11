import os
import sys

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import streamlit as st

st.set_page_config(
    page_title="Sales Analytics Platform",
    layout="wide"
)

st.title("Sales Analytics Platform")

st.markdown(
    """
    ### Executive Dashboard

    This dashboard provides insights into:

    - Revenue Performance
    - Customer Trends
    - Product Performance
    - Shipping Operations

    Use the sidebar to navigate through reports.
    """
)

st.info(
    "Select a page from the left navigation menu."
)
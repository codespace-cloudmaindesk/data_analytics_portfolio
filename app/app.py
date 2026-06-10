import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import streamlit as st

st.set_page_config(
    page_title="Analytics Platform",
    layout="wide"
)

st.title("Sales Analytics Platform")

st.markdown("""
Welcome to the dashboard.

Use the navigation menu on the left to access:

- Overview
- Trends
- Details
""")
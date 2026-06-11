import streamlit as st
from scripts.transformation import format_number


def render_kpis(kpis):

    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Revenue",
        f"{format_number(kpis['revenue'])}"
    )

    col2.metric(
        "Orders",
        format_number(kpis["orders"])
    )

    col3.metric(
        "Customers",
        format_number(kpis["customers"])
    )

    col4.metric(
        "Avg Shipping",
        f"{kpis['shipping_days']:.1f} days"
    )
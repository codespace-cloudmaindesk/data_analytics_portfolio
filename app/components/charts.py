import streamlit as st
import plotly.express as px


def revenue_trend(monthly_df):

    monthly_df["period"] = monthly_df["month_start"].astype(str).str[:7]

    fig = px.line(
        monthly_df,
        x="period",
        y="sales_amount",
        title="Revenue Trend"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

def category_chart(df):

    fig = px.bar(
        df,
        x="category",
        y="sales_amount",
        color="category",
        title="Revenue by Category"
    )

    st.plotly_chart(
        fig,
        width='stretch'
    )


def country_chart(df):

    fig = px.bar(
        df,
        x="country",
        y="sales_amount",
        title="Revenue by Country"
    )

    st.plotly_chart(
        fig,
        width='stretch'
    )
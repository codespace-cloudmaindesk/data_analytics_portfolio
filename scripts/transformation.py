# scripts/transformations.py

import pandas as pd


def calculate_kpis(df):
    return {
        "revenue": df["sales_amount"].sum(),
        "orders": df["order_number"].nunique(),
        "customers": df["customer_id"].nunique(),
        "shipping_days": df["shipping_days"].mean(),
    }


def monthly_sales(df):
    return (
        df.groupby("month_start")["sales_amount"]
        .sum()
        .reset_index()
    )


def category_sales(df):
    return (
        df.groupby("category")["sales_amount"]
        .sum()
        .sort_values(ascending=False)
        .reset_index()
    )


def country_sales(df):
    return (
        df.groupby("country")["sales_amount"]
        .sum()
        .sort_values(ascending=False)
        .reset_index()
    )


def top_products(df):
    return (
        df.groupby("product")["sales_amount"]
        .sum()
        .nlargest(10)
        .reset_index()
    )


def shipping_performance(df):
    return (
        df.groupby("country")["shipping_days"]
        .mean()
        .sort_values(ascending=False)
        .reset_index()
    )

def format_number(value):
    if value is None or pd.isna(value):
        return "N/A"

    for divisor, suffix in (
        (1_000_000_000_000, "T"),
        (1_000_000_000, "B"),
        (1_000_000, "M"),
        (1_000, "K"),
    ):
        if abs(value) >= divisor:
            formatted = f"{value / divisor:.1f}".rstrip("0").rstrip(".")
            return f"{formatted}{suffix}"

    return f"{value:,.0f}"
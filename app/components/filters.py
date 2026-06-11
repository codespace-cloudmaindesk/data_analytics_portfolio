import streamlit as st


def render_filters(df):

    with st.sidebar:

        st.header("Filters")

        countries = ["All"] + sorted(df["country"].dropna().unique())

        categories = ["All"] + sorted(df["category"].dropna().unique())

        country = st.selectbox(
            "Country",
            countries
        )

        category = st.selectbox(
            "Category",
            categories
        )

    filtered_df = df.copy()

    if country != "All":
        filtered_df = filtered_df[
            filtered_df["country"] == country
        ]

    if category != "All":
        filtered_df = filtered_df[
            filtered_df["category"] == category
        ]

    return filtered_df
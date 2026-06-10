import streamlit as st

st.set_page_config(
    page_title="Analytics App",
    layout="centered"
)

st.title("App Under Construction")

st.write("""
This is a placeholder Streamlit app.
The full dashboard will be added soon.
""")

st.info("App is running successfully")

name = st.text_input("Enter your name (test input):")

if name:
    st.success(f"Hello {name}, everything is working fine")

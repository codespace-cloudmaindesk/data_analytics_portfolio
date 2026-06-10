from scripts.loader import run_sql_file

SQL_FILES = [
    "setup/01_create_schemas.sql",

    "bronze/02_create_tables.sql",
    "bronze/03_load_cust_info.sql",
    "bronze/04_load_prd_info.sql",
    "bronze/05_load_sales_info.sql",
    "bronze/06_load_geo_info.sql",

    "silver/01_crm_cust.sql",
    "silver/02_erp_cust.sql",
    "silver/03_erp_loc.sql",
    "silver/04_erp_prd.sql",
    "silver/05_crm_prd.sql",
    "silver/06_crm_sales.sql",

    "gold/01_dim_customers.sql",
    "gold/02_dim_product.sql",
    "gold/03_fact_sales.sql",
    "gold/04_reporting_mart.sql"
]


def run_pipeline():
    for file in SQL_FILES:
        print(f"Running {file}")
        run_sql_file(file)

    print("Pipeline Complete")

if __name__ == "__main__":
    run_pipeline()
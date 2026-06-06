CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id TEXT,
    cst_key TEXT,
    cst_first_name TEXT,
    cst_last_name TEXT,
    cst_marital_status TEXT,
    cst_gndr TEXT,
    cst_create_date TEXT
);

CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid TEXT,
    bdate TEXT,
    gen TEXT
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid TEXT,
    cntry TEXT
);
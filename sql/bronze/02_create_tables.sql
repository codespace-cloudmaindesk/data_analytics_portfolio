CREATE SCHEMA IF NOT EXISTS bronze;


----Create tables in bronze schema related to customer information data from CRM system
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id TEXT,
    cst_key TEXT,
    cst_first_name TEXT,
    cst_last_name TEXT,
    cst_marital_status TEXT,
    cst_gndr TEXT,
    cst_create_date TEXT
);

----Create tables in bronze schema related to customer information data from ERP system
CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid TEXT,
    bdate TEXT,
    gen TEXT
);

----Create tables in bronze schema related to location data from ERP system ----
CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid TEXT,
    cntry TEXT
);

----Create tables in bronze schema related to product data from CRM system ----
CREATE TABLE IF NOT EXISTS bronze.crm_prod_info (
    prd_id TEXT,
    prd_key TEXT,
    prd_nm TEXT,
    prd_cost TEXT,
    prd_line TEXT,
    prd_start_dt TEXT,
    prd_end_dt TEXT
);

----Create tables in bronze schema related to product category data from ERP system -----
CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    id TEXT,
    cat TEXT,
    subcat TEXT,
    maintenance TEXT
);

----Create tables in bronze schema related to sales data from CRM system -----
CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num TEXT,
    sls_prd_key TEXT,
    sls_cust_id TEXT,
    sls_order_dt TEXT,
    sls_ship_dt TEXT,
    sls_due_dt TEXT,
    sls_sales TEXT,
    sls_quantity TEXT,
    sls_price TEXT
);
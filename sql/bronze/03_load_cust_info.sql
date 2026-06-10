TRUNCATE TABLE bronze.crm_cust_info;
COPY bronze.crm_cust_info (
    cst_id,
    cst_key,
    cst_first_name,
    cst_last_name,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
FROM '/data/source_crm/cust_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

TRUNCATE TABLE bronze.erp_cust_az12;
COPY bronze.erp_cust_az12 (
    cid,
    bdate,
    gen
)
FROM '/data/source_erp/cust_az12.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
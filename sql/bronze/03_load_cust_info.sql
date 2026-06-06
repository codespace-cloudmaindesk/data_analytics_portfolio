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
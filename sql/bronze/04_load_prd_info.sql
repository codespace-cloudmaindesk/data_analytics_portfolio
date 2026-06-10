TRUNCATE TABLE bronze.crm_prod_info;
COPY bronze.crm_prod_info (
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
) 
FROM '/data/source_crm/prd_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
COPY bronze.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
FROM '/data/source_erp/px_cat_g1v2.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
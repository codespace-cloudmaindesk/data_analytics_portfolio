TRUNCATE TABLE bronze.crm_sales_details;
COPY bronze.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
FROM '/data/source_crm/sales_details.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
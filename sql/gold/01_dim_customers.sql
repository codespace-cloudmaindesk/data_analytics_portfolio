CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY crm.customer_key) AS customer_key,
    crm.customer_id,
    crm.first_name,
    crm.last_name,
    crm.marital_status,
    erp.gender,
    erp.birth_date,
    loc.country,
    crm.create_date
FROM silver.crm_cust_info crm 
LEFT JOIN silver.erp_cust_az12 erp 
    ON crm.customer_key = erp.customer_key
LEFT JOIN silver.erp_loc_a101 loc
    ON crm.customer_id = loc.customer_id;

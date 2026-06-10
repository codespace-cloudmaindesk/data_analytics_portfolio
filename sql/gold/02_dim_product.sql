CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY crm.product_key) AS product_key,
    crm.product_key AS product_number,
    crm.product_id,
    crm.category_id,
    crm.product,
    crm.cost,
    crm.product_line,
    erp.category,
    erp.subcategory,
    erp.maintenance
FROM silver.crm_prd_info crm
LEFT JOIN silver.erp_px_cat_g1v2 erp
    ON crm.category_id = erp.category_id;
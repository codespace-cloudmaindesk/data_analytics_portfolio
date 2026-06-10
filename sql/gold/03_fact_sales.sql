CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    sls.order_number,
    prd.product_key,
    cst.customer_key,
    sls.order_date,
    sls.shipping_date,
    sls.due_date,
    sls.sales_amount,
    sls.quantity,
    sls.price
FROM silver.crm_sales sls
LEFT JOIN gold.dim_product prd
    ON sls.product_key = prd.product_number
LEFT JOIN gold.dim_customer cst
    ON sls.customer_id = cst.customer_id;

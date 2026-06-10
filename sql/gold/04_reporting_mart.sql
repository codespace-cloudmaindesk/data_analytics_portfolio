CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.reporting_mart AS
SELECT
    f.order_number,
    f.order_date,
    f.sales_amount,
    f.quantity,
    f.price,
    p.category,
    c.country,
    c.customer_id,
    (f.shipping_date - f.order_date) AS shipping_days
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON f.product_key = p.product_key
LEFT JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key;
CREATE SCHEMA IF NOT EXISTS gold;

DROP VIEW IF EXISTS gold.reporting_mart;

CREATE OR REPLACE VIEW gold.reporting_mart AS
SELECT
    f.order_number,

    f.order_date,
    f.due_date,
    f.shipping_date,

    EXTRACT(YEAR FROM f.order_date)  AS order_year,
    EXTRACT(MONTH FROM f.order_date) AS order_month,
    TO_CHAR(f.order_date, 'Mon')     AS month_name,
    DATE_TRUNC('month', f.order_date)::date AS month_start,


    p.product,
    p.category,
    p.subcategory,

    c.customer_id,
    c.country,
    c.gender,

    f.quantity,
    f.price,
    f.sales_amount,

    (f.shipping_date - f.order_date) AS shipping_days,

    CASE
        WHEN (f.shipping_date - f.order_date) <= 3 THEN 'Fast'
        WHEN (f.shipping_date - f.order_date) <= 7 THEN 'Average'
        ELSE 'Slow'
    END AS shipping_bucket,

    CASE
        WHEN f.sales_amount >= 1000 THEN 'High Value'
        WHEN f.sales_amount >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_segment

FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON f.product_key = p.product_key
LEFT JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key;
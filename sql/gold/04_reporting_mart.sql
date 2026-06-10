CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.mart_executive_summary AS

WITH base AS (
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
        ON f.product_key = p.product_id
    LEFT JOIN gold.dim_customer c
        ON f.customer_key = c.customer_id
)

SELECT
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_revenue,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(AVG(sales_amount), 2) AS avg_order_value,
    ROUND(AVG(price), 2) AS avg_selling_price,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_time,

    MAX(sales_amount) AS highest_single_order,
    MIN(sales_amount) AS lowest_single_order,

    COUNT(DISTINCT category) AS product_categories,
    COUNT(DISTINCT country) AS countries_served

FROM base;
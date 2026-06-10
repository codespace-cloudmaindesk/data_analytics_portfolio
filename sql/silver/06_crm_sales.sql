CREATE OR REPLACE VIEW silver.crm_sales AS

WITH source AS (
    SELECT *
    FROM bronze.crm_sales_details
    WHERE sls_ord_num IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(sls_ord_num) AS order_number,
        TRIM(sls_prd_key) AS product_key,
        CONCAT('AW', LPAD(TRIM(sls_cust_id),8,'0')) AS customer_id,

        CASE
            WHEN TRIM(sls_order_dt) !~ '^\d{8}$'
            THEN NULL
            ELSE TRIM(sls_order_dt)::DATE
        END AS order_date,

        CASE
            WHEN TRIM(sls_ship_dt) !~ '^\d{8}$'
            THEN NULL
            ELSE TRIM(sls_ship_dt)::DATE
        END AS shipping_date,

        CASE
            WHEN TRIM(sls_due_dt) !~ '^\d{8}$'
            THEN NULL
            ELSE TRIM(sls_due_dt)::DATE
        END AS due_date,

        NULLIF(TRIM(sls_sales),'')::NUMERIC AS sales_amount,
        NULLIF(TRIM(sls_quantity),'')::NUMERIC AS quantity,
        NULLIF(TRIM(sls_price),'')::NUMERIC AS price

    FROM source
)

SELECT
    order_number,
    product_key,
    customer_id,
    order_date,
    shipping_date,
    due_date,
    COALESCE(sales_amount, quantity * price) AS sales_amount,
    quantity,
    price
FROM cleaned;
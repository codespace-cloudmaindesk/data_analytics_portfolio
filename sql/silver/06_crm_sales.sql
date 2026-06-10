CREATE SCHEMA IF NOT EXISTS silver;

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
        CONCAT('AW', LPAD(TRIM(sls_cust_id), 8, '0')) AS customer_id,
        NULLIF(TRIM(sls_order_dt), '')::DATE AS order_date,
        NULLIF(TRIM(sls_ship_dt), '')::DATE AS shipping_date,
        NULLIF(TRIM(sls_due_dt), '')::DATE AS due_date,
        NULLIF(TRIM(sls_sales), '')::NUMERIC AS sales_amount,
        NULLIF(TRIM(sls_quantity), '')::NUMERIC AS quantity,
        NULLIF(TRIM(sls_price), '')::NUMERIC AS price

    FROM source
),

standardized AS (
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
    FROM cleaned
),

data_quality AS (
    SELECT
        *,
        CASE WHEN product_key IS NULL THEN 1 ELSE 0 END AS is_missing_product,
        CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END AS is_missing_customer,
        CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END AS is_missing_sales,
        CASE WHEN quantity IS NULL THEN 1 ELSE 0 END AS is_missing_quantity,
        CASE WHEN price IS NULL THEN 1 ELSE 0 END AS is_missing_price,
        CASE WHEN sales_amount < 0 THEN 1 ELSE 0 END AS is_negative_sales,
        CASE WHEN quantity < 0 THEN 1 ELSE 0 END AS is_negative_quantity,
        CASE WHEN price < 0 THEN 1 ELSE 0 END AS is_negative_price,

        CASE 
            WHEN sales_amount = 0 AND COALESCE(quantity,0) > 0 THEN 1 
            ELSE 0 
        END AS is_suspicious_zero_sales,
        CASE
            WHEN shipping_date < order_date THEN 1
            ELSE 0
        END AS is_invalid_shipping_date,

        CASE
            WHEN due_date < order_date
            THEN 1
            ELSE 0
        END AS is_invalid_due_date

    FROM standardized
)

SELECT
    order_number,
    product_key,
    customer_id,

    order_date,
    shipping_date,
    due_date,

    sales_amount,
    quantity,
    price,

    is_missing_product,
    is_missing_customer,
    is_missing_sales,
    is_missing_quantity,
    is_missing_price,

    is_negative_sales,
    is_negative_quantity,
    is_negative_price,

    is_suspicious_zero_sales,

    is_invalid_shipping_date,
    is_invalid_due_date

FROM data_quality;
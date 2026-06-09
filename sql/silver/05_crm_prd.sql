CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.crm_prd_info AS

WITH source AS (
    SELECT *
    FROM bronze.crm_prod_info
    WHERE prd_id IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(prd_id) AS product_id,
        TRIM(prd_key) AS product_key,
        TRIM(prd_nm) AS product,
        NULLIF(TRIM(prd_cost), '')::NUMERIC AS product_cost,
        NULLIF(TRIM(prd_line), '') AS product_line,
        NULLIF(TRIM(prd_start_dt), '')::DATE AS product_start_dt,
        NULLIF(TRIM(prd_end_dt), '')::DATE AS product_end_dt
    FROM source
),

standardized AS (
    SELECT
        *,
        CONCAT(
            SPLIT_PART(product_key, '-', 1),
            '_',
            SPLIT_PART(product_key, '-', 2)
        ) AS product_family_code
    FROM cleaned
),

data_quality AS (
    SELECT
        *,
        CASE WHEN product_id IS NULL THEN 1 ELSE 0 END AS is_missing_product_id,
        CASE WHEN product_cost IS NULL THEN 1 ELSE 0 END AS is_missing_cost,
        CASE WHEN product_line IS NULL THEN 1 ELSE 0 END AS is_missing_product_line,
        CASE WHEN product_end_dt IS NULL THEN 1 ELSE 0 END AS is_active_product,

        CASE
            WHEN product_id IS NULL
              OR product_cost IS NULL
              OR product_line IS NULL
            THEN 'Dirty'
            ELSE 'Clean'
        END AS dq_status

    FROM standardized
)
SELECT *
FROM data_quality;
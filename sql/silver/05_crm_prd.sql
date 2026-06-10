CREATE OR REPLACE VIEW silver.crm_prd_info AS

WITH source AS (
    SELECT *
    FROM bronze.crm_prd_info
    WHERE prd_id IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(prd_id) AS product_id,
        TRIM(prd_key) AS product_key,
        TRIM(prd_nm) AS product,
        NULLIF(TRIM(prd_cost), '')::NUMERIC AS cost,
        NULLIF(TRIM(prd_line), '') AS product_line,
        NULLIF(TRIM(prd_start_dt), '')::DATE AS start_dt,
        NULLIF(TRIM(prd_end_dt), '')::DATE AS end_dt
    FROM source
),

standardized AS (
    SELECT
        product_id,

        REGEXP_REPLACE(
            product_key,
            '^[^-]+-[^-]+-', ''
        ) AS product_key,

        CONCAT(
            SPLIT_PART(product_key, '-', 1),
            '_',
            SPLIT_PART(product_key, '-', 2)
        ) AS category_id,
        product,
        CASE
            WHEN product_line = 'M' THEN 'Mountain'
            WHEN product_line = 'R' THEN 'Road'
            WHEN product_line = 'S' THEN 'Other Sales'
            WHEN product_line = 'T' THEN 'Touring'
            ELSE 'Other'
        END AS product_line,

        COALESCE(cost, 0) AS cost,
        start_dt,
        end_dt
    FROM cleaned
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY product_key
            ORDER BY start_dt DESC NULLS LAST
        ) AS rn
    FROM standardized
)

SELECT
    product_id,
    product_key,
    category_id,
    product,
    product_line,
    cost,
    start_dt,
    end_dt
FROM deduped
WHERE rn = 1;
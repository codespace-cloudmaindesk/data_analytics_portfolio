CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.erp_loc_a101 AS

WITH source AS (
    SELECT *
    FROM bronze.erp_loc_a101
    WHERE cid IS NOT NULL
),
cleaned AS (
    SELECT
        TRIM(cid) AS cid,
        TRIM(cntry) AS cntry
    FROM source
),
standardized AS (
    SELECT 
        REPLACE(cid, '-', '') AS customer_key,
        CASE
            WHEN cntry IN ('US', 'USA', 'United States') THEN 'United States'
            WHEN cntry IN ('DE', 'Germany') THEN 'Germany'
            ELSE NULL 
        END AS country
    FROM cleaned
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_key
            ORDER BY customer_key
        ) AS rn
    FROM standardized
),
data_quality AS (
    SELECT *,
        CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END AS is_missing_customer_key,
        CASE WHEN country IS NULL THEN 1 ELSE 0 END AS is_missing_country,

        CASE
            WHEN customer_key IS NULL
                OR country IS NULL
            THEN 'Dirty'
            ELSE 'Clean'
        END AS dq_status
    FROM deduped
)
SELECT
    customer_key,
    country,
    dq_status
FROM data_quality
WHERE rn = 1
  AND dq_status = 'Clean';
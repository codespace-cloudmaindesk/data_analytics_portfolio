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
        REPLACE(cid, '-', '') AS customer_id,
        CASE
            WHEN cntry IN ('US', 'USA', 'United States') THEN 'United States'
            WHEN cntry IN ('DE', 'Germany') THEN 'Germany'
            WHEN cntry = 'Australia' THEN 'Australia'
            WHEN cntry = 'Canada' THEN 'Canada'
            WHEN cntry = 'France' THEN 'France'
            WHEN cntry = 'United Kingdom' THEN 'United Kingdom'
            ELSE NULL 
        END AS country
    FROM cleaned
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY customer_id
        ) AS rn
    FROM standardized
),
data_quality AS (
    SELECT *,
        CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END AS is_missing_customer_id,
        CASE WHEN country IS NULL THEN 1 ELSE 0 END AS is_missing_country,

        CASE
            WHEN customer_id IS NULL
                OR country IS NULL
            THEN 'Dirty'
            ELSE 'Clean'
        END AS dq_status
    FROM deduped
)
SELECT
    customer_id,
    country,
    dq_status
FROM data_quality
WHERE rn = 1
  AND dq_status = 'Clean';
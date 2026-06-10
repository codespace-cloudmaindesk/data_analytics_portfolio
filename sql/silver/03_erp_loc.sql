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
)

SELECT
    REPLACE(cid, '-', '') AS customer_id,

    CASE
        WHEN cntry IN ('US','USA','United States') THEN 'United States'
        WHEN cntry IN ('DE','Germany') THEN 'Germany'
        WHEN cntry = 'Australia' THEN 'Australia'
        WHEN cntry = 'Canada' THEN 'Canada'
        WHEN cntry = 'France' THEN 'France'
        WHEN cntry = 'United Kingdom' THEN 'United Kingdom'
        ELSE NULL
    END AS country

FROM cleaned;
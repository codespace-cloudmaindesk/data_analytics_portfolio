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
            WHEN UPPER(TRIM(cntry)) IN ('US','USA','UNITED STATES') THEN 'United States'
            WHEN UPPER(TRIM(cntry)) IN ('DE','GERMANY') THEN 'Germany'
            WHEN UPPER(TRIM(cntry)) = 'AUSTRALIA' THEN 'Australia'
            WHEN UPPER(TRIM(cntry)) = 'CANADA' THEN 'Canada'
            WHEN UPPER(TRIM(cntry)) = 'FRANCE' THEN 'France'
            WHEN UPPER(TRIM(cntry)) IN ('UK','UNITED KINGDOM','GREAT BRITAIN') THEN 'United Kingdom'
            ELSE NULL
        END AS country

    FROM cleaned
)

SELECT
    customer_id,
    country
FROM standardized;
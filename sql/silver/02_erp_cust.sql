CREATE OR REPLACE VIEW silver.erp_cust_az12 AS

WITH source AS (
    SELECT *
    FROM bronze.erp_cust_az12
    WHERE cid IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(cid) AS cid,
        TRIM(bdate) AS bdate,
        TRIM(gen) AS gen
    FROM source
),

standardized AS (
    SELECT
        CAST(NULLIF(REGEXP_REPLACE(cid, '\D', '', 'g'), '') AS INT) AS customer_key,
        REPLACE(cid, 'NAS', '') AS customer_id,

        CASE
            WHEN gen LIKE 'M%' THEN 'Male'
            WHEN gen LIKE 'F%' THEN 'Female'
            ELSE NULL
        END AS gender,

        NULLIF(TRIM(bdate), '')::DATE AS birth_date
    FROM cleaned
)

SELECT DISTINCT ON (customer_key)
    customer_key,
    customer_id,
    gender,
    birth_date
FROM standardized
ORDER BY customer_key, birth_date DESC NULLS LAST;
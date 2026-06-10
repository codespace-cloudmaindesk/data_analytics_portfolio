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

        NULLIF(bdate, '')::DATE AS birth_date
    FROM cleaned
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_key
            ORDER BY birth_date DESC NULLS LAST
        ) AS rn
    FROM standardized
)

SELECT
    customer_key,
    customer_id,
    gender,
    birth_date
FROM deduped
WHERE rn = 1;
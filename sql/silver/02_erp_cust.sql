CREATE SCHEMA IF NOT EXISTS silver;

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
),

deduped AS (
    SELECT DISTINCT ON (customer_key)
        customer_key,
        customer_id,
        gender,
        birth_date
    FROM standardized
    ORDER BY customer_key, birth_date DESC NULLS LAST
),

data_quality AS (
    SELECT *,
        CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END AS is_missing_customer_id,
        CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END AS is_missing_customer_key,
        CASE WHEN gender IS NULL THEN 1 ELSE 0 END AS is_missing_gender,
        CASE WHEN birth_date IS NULL THEN 1 ELSE 0 END AS is_missing_birth_date,

        CASE
            WHEN customer_key IS NULL
              OR customer_id IS NULL
              OR gender IS NULL
              OR birth_date IS NULL
            THEN 'Dirty'
            ELSE 'Clean'
        END AS dq_status
    FROM deduped
)

SELECT
    customer_key,
    customer_id,
    gender,
    birth_date,
    dq_status
FROM data_quality
WHERE dq_status = 'Clean';
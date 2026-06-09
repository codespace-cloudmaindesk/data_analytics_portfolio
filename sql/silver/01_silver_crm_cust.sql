CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.crm_cust_info AS

WITH source AS (
    SELECT *
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(cst_id) AS cst_id,
        TRIM(cst_key) AS cst_key,
        TRIM(cst_first_name) AS cst_first_name,
        TRIM(cst_last_name) AS cst_last_name,
        TRIM(cst_marital_status) AS cst_marital_status,
        TRIM(cst_gndr) AS cst_gndr,
        TRIM(cst_create_date) AS cst_create_date
    FROM source
),

standardized AS (
    SELECT
        cst_id,
        cst_key,
        cst_first_name,
        cst_last_name,

        CASE
            WHEN cst_marital_status IN ('M', 'Married') THEN 'Married'
            WHEN cst_marital_status IN ('S', 'Single') THEN 'Single'
            ELSE NULL
        END AS marital_status,

        CASE
            WHEN cst_gndr LIKE 'M%' THEN 'Male'
            WHEN cst_gndr LIKE 'F%' THEN 'Female'
            ELSE NULL
        END AS gender,

        cst_create_date
    FROM cleaned
),

casted AS (
    SELECT
        NULLIF(cst_id, '')::INT AS customer_id,
        cst_key AS customer_key,
        cst_first_name AS first_name,
        cst_last_name AS last_name,
        marital_status,
        gender,
        NULLIF(cst_create_date, '')::DATE AS create_date
    FROM standardized
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY create_date DESC NULLS LAST
        ) AS rn
    FROM casted
),

data_quality AS (
    SELECT *,
        CASE WHEN first_name IS NULL THEN 1 ELSE 0 END AS is_missing_first_name,
        CASE WHEN last_name IS NULL THEN 1 ELSE 0 END AS is_missing_last_name,
        CASE WHEN marital_status IS NULL THEN 1 ELSE 0 END AS is_invalid_marital_status,
        CASE WHEN gender IS NULL THEN 1 ELSE 0 END AS is_invalid_gender,
        CASE WHEN create_date IS NULL THEN 1 ELSE 0 END AS is_missing_create_date,

        CASE
            WHEN first_name IS NULL
              OR last_name IS NULL
              OR marital_status IS NULL
              OR gender IS NULL
              OR create_date IS NULL
            THEN 'Dirty'
            ELSE 'Clean'
        END AS dq_status
    FROM deduped
)

SELECT
    customer_id,
    customer_key,
    first_name,
    last_name,
    marital_status,
    gender,
    create_date,
    dq_status
FROM data_quality
WHERE rn = 1
  AND dq_status = 'Clean';
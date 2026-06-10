CREATE OR REPLACE VIEW silver.crm_cust_info_dq AS

SELECT
    customer_key,
    customer_id,
    first_name,
    last_name,
    marital_status,
    gender,
    create_date,

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

FROM silver.crm_cust_info;
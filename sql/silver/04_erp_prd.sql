CREATE OR REPLACE VIEW silver.erp_px_cat_g1v2 AS

WITH source AS (
    SELECT *
    FROM bronze.erp_px_cat_g1v2
    WHERE id IS NOT NULL
),

cleaned AS (
    SELECT
        TRIM(id) AS category_id,
        TRIM(cat) AS category,
        TRIM(subcat) AS subcategory,
        TRIM(maintenance) AS maintenance
    FROM source
)

SELECT *
FROM cleaned;
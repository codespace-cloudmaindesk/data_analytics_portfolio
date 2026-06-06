COPY bronze.erp_loc_a101 (
    cid,
    cntry
)
FROM '/data/source_erp/loc_a101.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
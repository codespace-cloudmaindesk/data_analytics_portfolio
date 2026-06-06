SELECT 'crm_cust_info' AS table_name, COUNT(*) FROM bronze.crm_cust_info
UNION ALL
SELECT 'erp_cust_az12', COUNT(*) FROM bronze.erp_cust_az12
UNION ALL
SELECT 'erp_cust_az34', COUNT(*) FROM bronze.erp_cust_az34
UNION ALL
SELECT 'erp_loc_a101', COUNT(*) FROM bronze.erp_loc_a101;
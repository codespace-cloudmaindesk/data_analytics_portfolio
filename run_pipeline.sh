#!/bin/bash

set -euo pipefail

DB_CONTAINER="data_analytics_portfolio-postgres-1"
DB_USER="postgres"
DB_NAME="analytics_db"

echo "Starting data pipeline..."

# Bronze Layer
echo "Processing Bronze Layer..."
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME  -f sql/setup/01_create_schemas.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/bronze/02_create_tables.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/bronze/03_load_cust_info.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/bronze/04_load_prd_info.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/bronze/05_load_sales_info.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/bronze/06_load_geo_info.sql
echo "Bronze Layer Processing Completed..."

# Silver Layer
echo "Processing Silver Layer..."
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/silver/01_crm_cust.sql
docker exec -i $DB_CONTAINER psql -v ON_ERROR_STOP=1 -U $DB_USER -d $DB_NAME -f sql/silver/02_erp_cust.sql
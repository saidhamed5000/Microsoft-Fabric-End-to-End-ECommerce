/* =====================================================================
   01_Dimensions.sql
   Sales_Warehouse - Dimension table build scripts
   Source: OneLake Shortcuts to the Silver Delta tables
   Run each block once, top to bottom, inside the Warehouse SQL editor.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- DimCustomer
-- ---------------------------------------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
INTO DimCustomer
FROM silver_customers;

-- ---------------------------------------------------------------------
-- DimProduct
-- ---------------------------------------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id,
    product_category_name_english,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
INTO DimProduct
FROM silver_products;

-- ---------------------------------------------------------------------
-- DimSeller
-- ---------------------------------------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
INTO DimSeller
FROM silver_sellers;

-- ---------------------------------------------------------------------
-- DimDate
-- NOTE: some Fabric Warehouse SQL versions restrict recursive CTEs.
-- If this block fails, build DimDate in a PySpark notebook instead
-- (pd.date_range from 2016-01-01 to 2018-12-31), save it as a Delta
-- table, then add it here as a OneLake Shortcut like the others.
-- ---------------------------------------------------------------------
WITH DateSeq AS (
    SELECT CAST('2016-01-01' AS DATE) AS full_date
    UNION ALL
    SELECT DATEADD(DAY, 1, full_date) FROM DateSeq WHERE full_date < '2018-12-31'
)
SELECT
    CAST(FORMAT(full_date, 'yyyyMMdd') AS INT) AS date_key,
    full_date,
    DAY(full_date) AS day,
    MONTH(full_date) AS month,
    FORMAT(full_date, 'MMMM') AS month_name,
    DATEPART(QUARTER, full_date) AS quarter,
    YEAR(full_date) AS year,
    CASE WHEN DATEPART(WEEKDAY, full_date) IN (1,7) THEN 1 ELSE 0 END AS is_weekend
INTO DimDate
FROM DateSeq
OPTION (MAXRECURSION 1100);

-- ---------------------------------------------------------------------
-- DimLocation (from the deduplicated/aggregated geolocation table)
-- ---------------------------------------------------------------------
SELECT
    geolocation_zip_code_prefix AS zip_prefix,
    lat, lng, city, state
INTO DimLocation
FROM silver_geolocation;

/* ---------------------------------------------------------------------
   Verification
   --------------------------------------------------------------------- */
-- SELECT COUNT(*) FROM DimCustomer;   -- expected ~99,441
-- SELECT COUNT(*) FROM DimProduct;    -- expected ~32,951
-- SELECT COUNT(*) FROM DimSeller;     -- expected ~3,095
-- SELECT COUNT(*) FROM DimDate;       -- expected ~1,096 (3 years)
-- SELECT COUNT(*) FROM DimLocation;   -- expected ~19,000-20,000

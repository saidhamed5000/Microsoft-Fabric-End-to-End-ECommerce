/* =====================================================================
   02_Facts.sql
   Sales_Warehouse - Fact table build scripts + foreign keys
   Run AFTER 01_Dimensions.sql, since these joins depend on the
   dimension tables and their surrogate keys.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- FactOrderItems
-- Joins order_items -> orders -> DimCustomer / DimProduct / DimSeller
-- ---------------------------------------------------------------------
SELECT
    oi.order_id,
    oi.order_item_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    CAST(FORMAT(o.order_purchase_timestamp, 'yyyyMMdd') AS INT) AS date_key,
    CAST(oi.price AS DECIMAL(10,2)) AS price,
    CAST(oi.freight_value AS DECIMAL(10,2)) AS freight_value,
    CAST(oi.price AS DECIMAL(10,2)) + CAST(oi.freight_value AS DECIMAL(10,2)) AS revenue
INTO FactOrderItems
FROM silver_order_items oi
JOIN silver_orders o ON oi.order_id = o.order_id
JOIN DimCustomer c ON o.customer_id = c.customer_id
JOIN DimProduct p ON oi.product_id = p.product_id
JOIN DimSeller s ON oi.seller_id = s.seller_id;

-- ---------------------------------------------------------------------
-- FactPayments
-- ---------------------------------------------------------------------
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    CAST(payment_value AS DECIMAL(10,2)) AS payment_value
INTO FactPayments
FROM silver_payments;

-- ---------------------------------------------------------------------
-- Foreign Keys (NOT ENFORCED - documents relationships for the
-- optimizer / semantic model without insert-time overhead)
-- ---------------------------------------------------------------------
ALTER TABLE FactOrderItems ADD CONSTRAINT FK_Customer
    FOREIGN KEY (customer_key) REFERENCES DimCustomer(customer_key) NOT ENFORCED;

ALTER TABLE FactOrderItems ADD CONSTRAINT FK_Product
    FOREIGN KEY (product_key) REFERENCES DimProduct(product_key) NOT ENFORCED;

ALTER TABLE FactOrderItems ADD CONSTRAINT FK_Seller
    FOREIGN KEY (seller_key) REFERENCES DimSeller(seller_key) NOT ENFORCED;

ALTER TABLE FactOrderItems ADD CONSTRAINT FK_Date
    FOREIGN KEY (date_key) REFERENCES DimDate(date_key) NOT ENFORCED;

/* ---------------------------------------------------------------------
   Verification
   --------------------------------------------------------------------- */
-- SELECT COUNT(*) FROM FactOrderItems;                                -- expected ~112,650
-- SELECT COUNT(*) FROM FactOrderItems WHERE customer_key IS NULL;     -- expected 0
-- SELECT COUNT(*) FROM FactOrderItems WHERE product_key IS NULL;      -- expected 0
-- SELECT COUNT(*) FROM FactOrderItems WHERE seller_key IS NULL;       -- expected 0
-- SELECT COUNT(*) FROM FactPayments;                                  -- expected ~103,886

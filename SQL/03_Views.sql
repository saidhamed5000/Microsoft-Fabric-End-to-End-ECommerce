/* =====================================================================
   03_Views.sql
   Sales_Warehouse - Reporting views
   Run AFTER 01_Dimensions.sql and 02_Facts.sql.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- vw_MonthlySales
-- Monthly revenue and order counts for trend reporting
-- ---------------------------------------------------------------------
CREATE VIEW vw_MonthlySales AS
SELECT
    d.year,
    d.month_name,
    SUM(f.revenue) AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM FactOrderItems f
JOIN DimDate d ON f.date_key = d.date_key
GROUP BY d.year, d.month_name;
GO

-- ---------------------------------------------------------------------
-- vw_DeliveryByState
-- Late-delivery rate and average delivery days per customer state
-- ---------------------------------------------------------------------
CREATE VIEW vw_DeliveryByState AS
SELECT
    c.customer_state,
    AVG(CASE WHEN o.DeliveryStatus = 'Late' THEN 1.0 ELSE 0.0 END) AS late_rate,
    AVG(o.DeliveryDays) AS avg_delivery_days
FROM silver_orders o
JOIN DimCustomer c ON o.customer_id = c.customer_id
GROUP BY c.customer_state;
GO

/* ---------------------------------------------------------------------
   Test queries
   --------------------------------------------------------------------- */
-- SELECT TOP 10 * FROM vw_MonthlySales ORDER BY year, month_name;
-- SELECT TOP 10 * FROM vw_DeliveryByState ORDER BY late_rate DESC;

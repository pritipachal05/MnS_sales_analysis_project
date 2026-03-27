/* 
 Marks & Spencer Retail Sales Analysis
 Phase 2: Data Cleaning & Exploration
 Author: Priti Pachal
 Objective: Audit raw data quality, remove invalid records,
 and create a clean view for all downstream KPI analysis.
 Raw data is preserved — exclusions applied via VIEW only.
*/ 


/* 
 Step 1: Full data quality audit
 Identifies all data quality issues before any cleaning.
 Results documented in project README under Data Quality Findings.
*/
SELECT
    COUNT(*)                                                    AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)       AS missing_customer_id,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END)       AS missing_description,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END)             AS zero_or_negative_qty,
    SUM(CASE WHEN price <= 0 THEN 1 ELSE 0 END)                AS zero_or_negative_price,
    SUM(CASE WHEN invoice_no LIKE 'C%' THEN 1 ELSE 0 END)      AS cancellation_rows
FROM transactions;


-- Step 2: Cancellation analysis
-- Quantifies the revenue impact of cancelled orders.

SELECT
    COUNT(*)                            AS cancelled_transactions,
    COUNT(DISTINCT customer_id)         AS customers_who_cancelled,
    COUNT(DISTINCT country)             AS countries,
    ROUND(SUM(quantity * price), 2)     AS cancelled_revenue_impact_gbp
FROM transactions
WHERE invoice_no LIKE 'C%';



-- Step 3: Create a clean transactions view
-- Excludes all invalid records identified in the audit.

CREATE VIEW ms_clean_transactions AS
SELECT
    invoice_no                          AS order_id,
    stock_code                          AS product_code,
    description                         AS product_name,
    quantity                            AS units_sold,
    invoice_date                        AS order_date,
    price                               AS unit_price_gbp,
    customer_id,
    country,
    ROUND(quantity * price, 2)          AS revenue
FROM transactions
WHERE
    invoice_no NOT LIKE 'C%'        -- exclude cancellations
    AND quantity > 0                -- exclude returns and zero-qty rows
    AND price > 0                   -- exclude zero/negative price rows
    AND customer_id IS NOT NULL     -- exclude anonymous transactions
    AND description IS NOT NULL;    -- exclude rows with no product info



-- Step 4: Explore country distribution
-- Business question: How significant is M&S's international trade vs domestic UK sales?

SELECT
    country,
    COUNT(*)                            AS transactions,
    COUNT(DISTINCT customer_id)         AS unique_customers,
    ROUND(SUM(revenue), 2)     AS total_revenue_gbp
FROM ms_clean_transactions
GROUP BY country
ORDER BY total_revenue_gbp DESC
LIMIT 10;


-- Step 5: Explore monthly transaction volume
-- Business question: Are there clear seasonal trading peaks?

SELECT
    SUBSTR(order_date, 7, 4)    AS year,
    SUBSTR(order_date, 4, 2)    AS month,
    COUNT(*)                    AS transactions,
    COUNT(DISTINCT order_id)    AS unique_orders
FROM ms_clean_transactions
GROUP BY year, month
ORDER BY year, month;


-- Step 6: Explore product price range

SELECT
    MIN(unit_price_gbp)             AS lowest_price,
    MAX(unit_price_gbp)             AS highest_price,
    ROUND(AVG(unit_price_gbp), 2)   AS avg_unit_price
FROM ms_clean_transactions;


-- Step 7: Final validation of clean view
-- Confirms zero nulls remain and row count is as expected.

SELECT
    COUNT(*)                                            AS clean_rows,
    COUNT(DISTINCT customer_id)                         AS unique_customers,
    COUNT(DISTINCT order_id)                            AS unique_orders,
    COUNT(DISTINCT product_code)                        AS unique_products,
    ROUND(SUM(revenue), 2)                    AS net_revenue_gbp,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS nulls_remaining
FROM ms_clean_transactions;


-- =============================================================
-- Phase 2 complete.
-- Clean view ms_clean_transactions created and validated.
-- =============================================================

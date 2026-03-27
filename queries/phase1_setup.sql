/* 
 Marks & Spencer Retail Sales Analysis
 Phase 1: Database Setup & Data Loading
 Author: Priti Pachal
 Objective: Create the transactions table, load raw retail
 data from two CSV sources, and validate successful ingestion.
*/

/*
 Step 1: Create the raw transactions table
 Stores all fields from the source CSV exactly as exported.
 Column names use M&S business terminology throughout.
*/

CREATE TABLE transactions (
    invoice_no    TEXT,       -- Order ID. Prefix 'C' = cancellation
    stock_code    TEXT,       -- M&S product code
    description   TEXT,       -- Product name / description
    quantity      INTEGER,    -- Units sold (negative = return)
    invoice_date  TEXT,       -- Order date: DD/MM/YYYY HH:MM format
    price         REAL,       -- Unit price in GBP
    customer_id   TEXT,       -- Unique customer identifier (nullable)
    country       TEXT        -- Customer country
);


/*
 Step 2: Load data
 
 Two CSV files were imported via DB Browser for SQLite:
   retail_2009.csv  (Year 2009-2010 sheet)
   retail_2010.csv  (Year 2010-2011 sheet)

 Import settings used:
   - First row contains column names: YES
   - Field separator: comma
   - Encoding: UTF-8
   - Target table: transactions (append, not new table)
*/

-- Step 3: Validate ingestion — row count
-- Expected: ~1,000,000+ rows across both years

SELECT COUNT(*) AS total_rows
FROM transactions;


-- Step 4: Validate ingestion — data preview

SELECT *
FROM transactions
LIMIT 10;


-- Step 5: Validate ingestion — date range
-- Expected: earliest ~Feb 2010, latest ~Dec 2011

SELECT
    MIN(invoice_date) AS earliest_order,
    MAX(invoice_date) AS latest_order
FROM transactions;


-- Step 6: Full ingestion summary

SELECT
    COUNT(*)                       AS total_rows,
    COUNT(DISTINCT invoice_no)     AS unique_orders,
    COUNT(DISTINCT customer_id)    AS unique_customers,
    COUNT(DISTINCT country)        AS unique_countries,
    ROUND(SUM(quantity * price), 2) AS gross_revenue_gbp
FROM transactions;

-- =============================================================
-- Phase 1 complete.
-- Confirmed: 1,067,371 rows loaded across 2 sources.

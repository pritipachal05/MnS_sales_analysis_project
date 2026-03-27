/* 
 Marks & Spencer Retail Sales Analysis
 Phase 3: Revenue & Product KPIs
 Author: Priti Pachal
 Objective: Surface key commercial trading KPIs for the M&S buying, merchandising, and commercial director teams.
 All queries run against the ms_clean_transactions view.
*/ 

/* 
 KPI 1: Monthly revenue trend
 Business question: How did trading perform across the year?
 Insight: Look for the Nov-Dec seasonal gifting peak and any months with sharp dips worth investigating.
*/

SELECT
    SUBSTR(order_date, 7, 4)            AS year,
    SUBSTR(order_date, 4, 2)            AS month,
    COUNT(DISTINCT order_id)            AS total_orders,
    COUNT(DISTINCT customer_id)         AS active_customers,
    SUM(units_sold)                     AS total_units_sold,
    ROUND(SUM(revenue), 2)              AS monthly_revenue_gbp,
    ROUND(AVG(revenue), 2)              AS avg_order_line_value
FROM ms_clean_transactions
GROUP BY year, month
ORDER BY year, month;


/* KPI 2: Month-on-month revenue growth
 Business question: Are we growing or declining vs last month?
 Technique: CTE + LAG() window function
 Insight: Positive mom_growth_pct = growth vs prior month.
*/

WITH monthly_revenue AS (
    SELECT
        SUBSTR(order_date, 7, 4) || '-' ||
        SUBSTR(order_date, 4, 2)            AS year_month,
        ROUND(SUM(revenue), 2)              AS monthly_revenue
    FROM ms_clean_transactions
    GROUP BY year_month
)
SELECT
    year_month,
    monthly_revenue                         AS current_revenue_gbp,
    LAG(monthly_revenue) OVER (
        ORDER BY year_month
    )                                       AS prev_month_revenue_gbp,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year_month))
        / LAG(monthly_revenue) OVER (ORDER BY year_month) * 100
    , 1)                                    AS mom_growth_pct
FROM monthly_revenue
ORDER BY year_month;


/* KPI 3: Top 20 product lines by revenue
 Business question: Which products should the buying team prioritise for next season?
 Insight: High revenue + high units = hero product (volume).
 High revenue + low units = premium product (margin).
*/

SELECT
    product_code,
    product_name,
    COUNT(DISTINCT order_id)            AS orders_containing_product,
    SUM(units_sold)                     AS total_units_sold,
    ROUND(AVG(unit_price_gbp), 2)       AS avg_selling_price_gbp,
    ROUND(SUM(revenue), 2)              AS total_revenue_gbp
FROM ms_clean_transactions
GROUP BY product_code, product_name
ORDER BY total_revenue_gbp DESC
LIMIT 20;

/*
 KPI 4: Revenue by country
 Business question: How significant is M&S's international trade vs domestic UK sales?
 Insight: UK dominance expected. Flag the top 3 international markets as growth opportunities.
*/

SELECT
    country,
    COUNT(DISTINCT customer_id)         AS customers,
    COUNT(DISTINCT order_id)            AS orders,
    ROUND(SUM(revenue), 2)              AS total_revenue_gbp,
    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER ()
    , 2)                                AS pct_of_total_revenue
FROM ms_clean_transactions
GROUP BY country
ORDER BY total_revenue_gbp DESC;


/* 
 KPI 5: Average order value trend
 Business question: Are customers spending more or less per visit over time?
 Insight: Rising AOV = upsell success or premium shift.
 Falling AOV = promotional pressure or a change in customer mix.
*/

WITH order_totals AS (
    SELECT
        SUBSTR(order_date, 7, 4) || '-' ||
        SUBSTR(order_date, 4, 2)            AS year_month,
        order_id,
        SUM(revenue)                        AS order_value_gbp
    FROM ms_clean_transactions
    GROUP BY year_month, order_id
)
SELECT
    year_month,
    COUNT(order_id)                     AS total_orders,
    ROUND(AVG(order_value_gbp), 2)      AS avg_order_value_gbp,
    ROUND(MIN(order_value_gbp), 2)      AS min_order_value_gbp,
    ROUND(MAX(order_value_gbp), 2)      AS max_order_value_gbp
FROM order_totals
GROUP BY year_month
ORDER BY year_month;


-- =============================================================
-- Phase 3 complete.
-- KPIs delivered: monthly revenue, MoM growth, top products,
-- country breakdown, average order value trend.
-- =============================================================

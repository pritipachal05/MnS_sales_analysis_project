/* =============================================================
 Marks & Spencer Retail Sales Analysis
 Phase 4: Customer Analytics & RFM Segmentation
 Author: Priti Pachal
 Objective: Profile M&S customers, identify new vs returning split, and segment the full customer base using RFM scoring to surface actionable insights for the CRM & Loyalty team.
 All queries run against the ms_clean_transactions view.
 =============================================================
*/

/*
 Query 1: Customer summary profile
 -------------------------------------------------------------
 Business question: Who are our customers at a glance?
 Insight: Use these headline numbers as the opening stat in your Phase 4 README section.
*/

SELECT
    COUNT(DISTINCT customer_id)             AS total_customers,
    ROUND(AVG(customer_orders), 2)          AS avg_orders_per_customer,
    ROUND(AVG(customer_revenue), 2)         AS avg_revenue_per_customer_gbp,
    ROUND(MAX(customer_revenue), 2)         AS highest_customer_spend_gbp,
    ROUND(MIN(customer_revenue), 2)         AS lowest_customer_spend_gbp
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id)            AS customer_orders,
        ROUND(SUM(revenue), 2)              AS customer_revenue
    FROM ms_clean_transactions
    GROUP BY customer_id
) customer_summary;


/*
 Query 2: New vs returning customers by month
 -------------------------------------------------------------
 Business question: Are we acquiring new customers or
 retaining existing ones month by month?
 Presented to: Customer Acquisition & Retention teams
 Technique: Two chained CTEs + CASE WHEN classification
 Insight: Healthy retail = steady new acquisition AND growing returning base. 
 Skew toward returning only may signal that acquisition investment is needed.
*/

WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date)                     AS first_order_date
    FROM ms_clean_transactions
    GROUP BY customer_id
),
tagged_orders AS (
    SELECT
        t.customer_id,
        t.order_id,
        t.order_date,
        SUBSTR(t.order_date, 7, 4) || '-' ||
        SUBSTR(t.order_date, 4, 2)          AS year_month,
        CASE
            WHEN t.order_date = f.first_order_date
            THEN 'New'
            ELSE 'Returning'
        END                                 AS customer_type
    FROM ms_clean_transactions t
    JOIN first_orders f
        ON t.customer_id = f.customer_id
)
SELECT
    year_month,
    COUNT(DISTINCT CASE WHEN customer_type = 'New'
        THEN customer_id END)               AS new_customers,
    COUNT(DISTINCT CASE WHEN customer_type = 'Returning'
        THEN customer_id END)               AS returning_customers
FROM tagged_orders
GROUP BY year_month
ORDER BY year_month;


/*
 Query 3: RFM scores per customer
 -------------------------------------------------------------
 Business question: How do we score every customer across recency, frequency, and monetary value?
 Technique: NTILE(4) window function across all three RFM dimensions — score 4 = best, score 1 = worst.
 Insight: Customers with total_score = 12 are your most valuable. Score = 3 are lapsed or low-value.
*/

WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(order_date)                     AS last_order_date,
        COUNT(DISTINCT order_id)            AS frequency,
        ROUND(SUM(revenue), 2)              AS monetary
    FROM ms_clean_transactions
    GROUP BY customer_id
),
rfm_scored AS (
    SELECT
        customer_id,
        last_order_date,
        frequency,
        monetary,
        NTILE(4) OVER (
            ORDER BY last_order_date DESC
        )                                   AS recency_score,
        NTILE(4) OVER (
            ORDER BY frequency ASC
        )                                   AS frequency_score,
        NTILE(4) OVER (
            ORDER BY monetary ASC
        )                                   AS monetary_score
    FROM rfm_base
)
SELECT
    customer_id,
    last_order_date,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total_score
FROM rfm_scored
ORDER BY rfm_total_score DESC;


/*
 Query 4: RFM customer segments — headline output
 -------------------------------------------------------------
 Business question: Which customers need what commercial action from the CRM and marketing teams?
 Technique: Three chained CTEs + CASE WHEN segmentation using combined RFM scores

 Segment definitions:
   Champions      — recent, frequent, high spend. Protect.
   Loyal          — strong overall. Reward and upsell.
   Promising      — recent but low spend. Nurture.
   At Risk        — high value but lapsing. Reactivate.
   Needs Attention — average across all dimensions.
   Lost           — infrequent, old, low spend. Win-back or write off.
*/

WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(order_date)                     AS last_order_date,
        COUNT(DISTINCT order_id)            AS frequency,
        ROUND(SUM(revenue), 2)              AS monetary
    FROM ms_clean_transactions
    GROUP BY customer_id
),
rfm_scored AS (
    SELECT
        customer_id,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY last_order_date DESC)   AS r,
        NTILE(4) OVER (ORDER BY frequency ASC)          AS f,
        NTILE(4) OVER (ORDER BY monetary ASC)           AS m
    FROM rfm_base
),
rfm_segments AS (
    SELECT
        customer_id,
        frequency,
        monetary,
        r, f, m,
        r + f + m                           AS total_score,
        CASE
            WHEN r + f + m >= 10            THEN 'Champions'
            WHEN r + f + m >= 8             THEN 'Loyal Customers'
            WHEN r >= 3 AND f + m < 6       THEN 'Promising'
            WHEN r <= 2 AND f + m >= 6      THEN 'At Risk'
            WHEN r = 1 AND f = 1            THEN 'Lost'
            ELSE                                 'Needs Attention'
        END                                 AS customer_segment
    FROM rfm_scored
)
SELECT
    customer_segment,
    COUNT(*)                                AS customer_count,
    ROUND(AVG(frequency), 1)               AS avg_orders,
    ROUND(AVG(monetary), 2)                AS avg_spend_gbp,
    ROUND(SUM(monetary), 2)                AS total_segment_revenue_gbp
FROM rfm_segments
GROUP BY customer_segment
ORDER BY total_segment_revenue_gbp DESC;


-- =============================================================
-- Phase 4 complete.
-- Analyses delivered: customer profile summary, new vs returning split, individual RFM scores, segment summary.
-- SQL techniques used: CTEs (chained x3), NTILE(), ROW_NUMBER(), JOIN, CASE WHEN segmentation, conditional COUNT DISTINCT, SUBSTR() date parsing.
-- =============================================================

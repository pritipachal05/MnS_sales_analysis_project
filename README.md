# Marks & Spencer Retail Sales Analysis
### SQL Business Intelligence Project

---

## Project Overview

This project simulates the work of a Business Analyst within the **Marks & Spencer Commercial Trading team**, analysing transactional retail data to surface actionable insights for the buying, merchandising, and customer teams.

The analysis covers over **800,000 cleaned transactions** spanning 2010–2011, examining revenue trends, product performance, and customer behaviour across M&S's UK and international customer base.

---

## Business Context

As a BA embedded in the Commercial Trading team, the core objective was to answer the following business questions:

- How did revenue trend across the trading year, including peak seasonal periods?
- Which product lines drove the most value, and which are declining?
- How significant is the international customer base vs the domestic UK?
- What is the profile of our most loyal, high-value customers?
- What is the return rate, and what is the financial impact on net revenue?

---

## Tools & Skills

| Tool | Purpose |
|---|---|
| SQLite (DB Browser) | Database creation, querying, and analysis |
| SQL | Data cleaning, aggregation, KPI calculation, window functions |
| GitHub | Version control and project documentation |

---

## Project Structure

```
marks-spencer-ba-project/
├── README.md
├── queries/
│   ├── phase1_setup.sql          — Database setup and data loading
│   ├── phase2_cleaning.sql       — Data quality audit and clean view
│   ├── phase3_kpis.sql           — Revenue and product KPIs
│   └── phase4_customers.sql      — Customer analytics and RFM segmentation
```

---

## Data Source

**Dataset:** Online Retail II — UCI Machine Learning Repository  
**Source:** https://archive.ics.uci.edu/dataset/502/online+retail+ii  
**Period:** February 2010 – December 2011  
**Raw rows:** 1,067,371  
**Clean rows:** 805,549 (post data quality filtering)

> Note: This is a real UK retail transactional dataset used here in a simulated M&S business analysis context for portfolio purposes.

---
**Key Findings**
**Revenue & Trading Performance**

Total net revenue across the analysis period: £17743429.16
Peak trading month: Nov 2010 with £1,172,336.04 in revenue
Month-on-month growth ranged from -55.4% to 47.6%
Average order value across the period: £576.95

**Product Performance**

20 unique products analysed across the clean dataset
Top 5 products accounted for 5.62% of total net revenue
Highest revenue product: REGENCY CAKESTAND 3 TIER, generating £286486.3

**Geographic Breakdown**

United Kingdom accounted for 82.98% of total net revenue
Top 3 international markets: UK, EIRE, Netherlands 
41 countries represented in the total customer base

**Customer Analytics & RFM Segmentation**

Total unique customers analysed: 5878
Average revenue per customer: £3018.62
Average orders per customer: 6.29
Highest individual customer spend: £608821.65

**RFM Segment Summary:**

| Segment | Customers | Avg Orders | Avg Spend (£) | Total Revenue (£) |
|---|---|---|---|---|
| Champions | 758 | 10.0 | 5142.74 | 3898193.9 |
| Loyal Customers | 2261 | 10.5 | 5540.82 | 12527788.67 |
| Promising | 1668 | 1.4 | 301.44 | 502803.74 |
| Needs Attention | 869 | 2.5 | 537.89 | 467422.35 |
| At Risk | 220 | 4.8 | 1460.96 | 321410.33 |
| Lost | 102 | 1.0 | 253.04 | 25810.17 |

**Key CRM insight:** Champion customers generated **£[X]** in revenue. At Risk customers represent a **£[X]** reactivation opportunity for the M&S loyalty and CRM teams.

---
## Data Quality Findings

The following issues were identified and handled during the cleaning phase:

| Issue | Row Count | Action Taken |
|---|---|---|
| Cancelled orders (invoice starting with 'C') | 19494 | Excluded from clean view |
| Negative or zero quantity | 22950 | Excluded from clean view |
| Zero or negative price | 6207 | Excluded from clean view |
| Missing customer ID | 243007 | Excluded from clean view |
| Missing product description | 4382 | Excluded from clean view |

> Raw data was preserved in the original `transactions` table. All exclusions were applied via a SQL VIEW rather than deletion, in line with non-destructive data handling best practice.

---

## Phase Summary

### Phase 1 — Environment Setup
Set up a SQLite database, loaded raw transactional data from two CSV sources, and validated successful ingestion with row count and date range checks.

### Phase 2 — Data Cleaning & Exploration
Conducted a full data quality audit, identifying nulls, cancellations, and invalid records. Built a clean transaction view (`ms_clean_transactions`) excluding cancelled orders, zero-price rows, negative quantities, and anonymous transactions. Documented data quality findings below.

### Phase 3 — Revenue & Product KPIs
Delivered five commercial KPIs for the trading and buying teams: monthly revenue trend, month-on-month growth using `LAG` window function, top 20 products by revenue, country revenue breakdown with percentage share using `SUM OVER` window function, and average order value trend.

### Phase 4 — Customer Analytics & RFM Segmentation
Profiled the full customer base with summary statistics. Built a new vs returning customer split by month using chained CTEs and `JOIN`. Scored every customer across Recency, Frequency, and Monetary dimensions using `NTILE(4)` window functions. Segmented customers into six actionable groups — Champions, Loyal, Promising, Needs Attention, At Risk, and Lost — with revenue and order metrics per segment.

---

## Author

**Priti Pachal**  
Aspiring Business Analyst | Data Analysis  
https://www.linkedin.com/in/priti-pachal-b21a881b4/ | priti.pachal.05@gmail.com
# Marks & Spencer Retail Sales Analysis
### SQL Business Intelligence Project

---

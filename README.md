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

## Phase Summary

### Phase 1 — Environment Setup
Set up a SQLite database, loaded raw transactional data from two CSV sources, and validated successful ingestion with row count and date range checks.

### Phase 2 — Data Cleaning & Exploration
Conducted a full data quality audit, identifying nulls, cancellations, and invalid records. Built a clean transaction view (`ms_clean_transactions`) excluding cancelled orders, zero-price rows, negative quantities, and anonymous transactions. Documented data quality findings below.

### Phase 3 — Revenue & Product KPIs *(in progress)*
Monthly revenue trends, average order value, top product lines by revenue and volume, and month-on-month growth analysis.

### Phase 4 — Customer Analytics & RFM Segmentation *(in progress)*
New vs returning customer split, average customer spend, and RFM (Recency, Frequency, Monetary) segmentation to identify high-value customer tiers.

---

## Data Quality Findings — Phase 2

The following issues were identified and handled during the cleaning phase:

| Issue | Row Count | Action Taken |
|---|---|---|
| Cancelled orders (invoice starting with 'C') | 19,494 | Excluded from clean view |
| Negative or zero quantity | 22.950 | Excluded from clean view |
| Zero or negative price | 6,207 | Excluded from clean view |
| Missing customer ID | 243,007 | Excluded from clean view |
| Missing product description | 4,382 | Excluded from clean view |

> Raw data was preserved in the original `transactions` table. All exclusions were applied via a SQL VIEW rather than deletion, in line with non-destructive data handling best practice.

---

## Author

**Priti Pachal**  
Aspiring Business Analyst | Data Analysis  
https://www.linkedin.com/in/priti-pachal-b21a881b4/ | priti.pachal.05@gmail.com

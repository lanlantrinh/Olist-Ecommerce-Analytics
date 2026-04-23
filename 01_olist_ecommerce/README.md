# Olist E-commerce Analytics

An end-to-end data analytics portfolio project built on the Olist Brazilian E-commerce dataset. The project encompasses a data warehouse build in PostgreSQL and a high-impact BI suite in Power BI.

## Business Objective

The goal is to translate 100,000+ raw e-commerce transactions into a highly actionable C-level dashboard suite. The reporting targets three core business pillars:
1. **Financial Health:** Moving beyond volume metrics to analyze MoM% growth and true momentum.
2. **Supply Chain Operations:** Isolating seller processing delays from carrier transit bottlenecks.
3. **Customer Experience (CX):** Quantifying the exact cost of late deliveries on customer satisfaction (CSAT) and reviews.

## Dashboard Deliverables

The Power BI reporting layer (`Porfolio_Olist.pbix`) breaks down the complex Olist data model into three distinct, consultant-grade dashboards:

-   **Executive Overview:** Uncovers the "Illusion of Growth" by pairing absolute Revenue columns with a MoM% Growth secondary axis line, revealing that despite high volume, momentum stagnated in late 2018.
-   **Logistics Checkup:** Deconstructs the delivery lifecycle. Employs a bottleneck analysis to prove that average seller processing time stays stable at 3 days, while carrier transit times ballooned to 13+ days, effectively identifying the root cause of delays.
-   **CX & Service Impact:** Uses 100% Stacked Column charts to visually prove the direct correlation between "Delivered Late" statuses and massive spikes in 1-star reviews. Incorporates a dynamic Risk Matrix (Scatter Plot) to isolate underperforming product categories.

## Technical Execution & Data Engineering

To ensure the Power BI dashboard runs efficiently without multi-grain duplication risks, a robust SQL layer was constructed before visualization:

-   **Safe Joins & Star Schema:** Analyzed the risk of joining `order_items` (many per order) and `order_payments` (many per order) directly. 
-   **Pre-Aggregation Views:** Built `fact_orders` using SQL CTEs to aggregate item and payment tables before joining them to the base orders table, eliminating many-to-many cardinality errors.
-   **Advanced DAX:** Mitigated bidirectional filtering risks in the CX Scatter Plot by utilizing `CALCULATE` with `CROSSFILTER`, protecting the star schema's integrity while enabling cross-table analytics.

## Repository Structure

- `sql/`: Contains PostgreSQL schema, exploration scripts, and the final views (`04_create_views.sql`) establishing the analytical data model.
- `docs/`: Concise business case summaries.
- `scripts/`: Shell and PowerShell utility scripts for local database initialization.

## How To Run

Start the local PostgreSQL database:
```bash
./scripts/db-init.sh
```
Load the Olist CSV files:
```bash
./scripts/load_olist_csvs.sh "/path/to/olist-csv-folder"
```

## Why This Project Stands Out

This project goes beyond merely dragging charts onto a canvas. It focuses on validating data grain, safely orchestrating one-to-many relationships, and strictly adhering to executive "storytelling" principles (actionable insights over pure descriptive statistics).

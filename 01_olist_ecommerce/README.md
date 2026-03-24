# Olist E-commerce Sales Analysis

SQL analysis project built on the Olist Brazilian e-commerce dataset. The goal is to create a clean analytical layer in PostgreSQL before moving into Power BI dashboard development.

## Project Objective

This project answers three core business questions:

1. How does revenue change over time?
2. Which product categories generate the most revenue?
3. Do customers in certain states spend more?

The work intentionally starts with data validation before reporting so that metrics are based on the correct grain and safe joins.

## Business Context

E-commerce datasets often contain one-to-many relationships across orders, items, and payments. If those tables are joined naively, revenue can be overstated. This project focuses on building trustworthy metrics first, then shaping the output for dashboard use.

## Dataset

- Source: Kaggle Olist e-commerce dataset
- Time range: 2016-09-04 to 2018-10-17
- Core tables used: `customers`, `orders`, `products`, `order_items`, `order_payments`

## Tools

- PostgreSQL
- Docker
- SQL
- VS Code SQLTools / DBeaver
- Power BI

## Project Workflow

1. Load raw CSV files into PostgreSQL
2. Explore table grain, duplicates, nulls, and join risk
3. Build analytical views for dashboard-friendly reporting
4. Answer business questions in SQL
5. Use the SQL layer as the source for a Power BI dashboard

## Repository Structure

- [`sql/01_create_schema.sql`](./sql/01_create_schema.sql): schema for core tables used in the analysis
- [`sql/02_exploration.sql`](./sql/02_exploration.sql): data quality and relationship checks
- [`sql/03_analysis.sql`](./sql/03_analysis.sql): business analysis queries
- [`sql/04_create_views.sql`](./sql/04_create_views.sql): reusable analytical views
- [`docs/project_overview.md`](./docs/project_overview.md): concise business and project summary
- [`dashboard/powerbi_blueprint.md`](./dashboard/powerbi_blueprint.md): Power BI build plan, model, and starter DAX measures
- [`dashboard/powerbi_build_order.md`](./dashboard/powerbi_build_order.md): exact step-by-step order to build the dashboard
- [`dashboard/windows_powerbi_quickstart.md`](./dashboard/windows_powerbi_quickstart.md): short handoff checklist for building the dashboard on Windows
- [`scripts/load_olist_csvs.sh`](./scripts/load_olist_csvs.sh): load the required CSV files into PostgreSQL

## Data Quality Checks

Exploration was completed before analysis to confirm the correct reporting grain.

Key findings:

- `orders` is the correct base grain for order-level metrics
- 9,803 orders have multiple items
- 2,961 orders have multiple payment records
- 275 orders have many-to-many join risk if `order_items` and `order_payments` are joined directly
- 1 delivered order has items but no payment record: `bfbd0f9bdef84302105ad712db648a6c`
- There are 0 orphan item rows and 0 orphan payment rows

Analytical decision:

- Order-level revenue uses aggregated `payment_value`
- Category-level revenue uses aggregated item `price`
- Canceled and unavailable orders are excluded from revenue reporting

## Analytical Layer

Two reusable views were created to support both SQL analysis and Power BI:

- `clean_orders`: one row per order
- `clean_order_category_sales`: one row per order and product category

This avoids duplicate rows in downstream reporting and keeps business logic reusable.

## Key Insights

- The dataset covers 24 active purchase months and approximately `15.74M` in revenue after excluding canceled and unavailable orders
- Top revenue categories are `beleza_saude`, `relogios_presentes`, and `cama_mesa_banho`
- Top revenue states are `SP`, `RJ`, and `MG`
- Sao Paulo (`SP`) contributes the largest share of total revenue by a wide margin

## Dashboard Plan

The next Power BI stage will focus on:

- monthly revenue trend
- top categories by revenue
- sales by customer state
- order volume and average order value
- filters for date and geography

Add dashboard screenshots here once the Power BI report is complete.

## How To Run

Start the local PostgreSQL database:

```bash
cd path/to/portfolio/01_olist_ecommerce
./scripts/db-init.sh
```

On Windows PowerShell:

```powershell
cd path\to\portfolio\01_olist_ecommerce
.\scripts\db-init.ps1
```

Load the Olist CSV files:

```bash
./scripts/load_olist_csvs.sh "/path/to/olist-csv-folder"
```

On Windows PowerShell:

```powershell
.\scripts\load_olist_csvs.ps1 "C:\path\to\olist-csv-folder"
```

Open a SQL shell:

```bash
./scripts/psql.sh
```

Connection details for a SQL client:

- Host: `localhost`
- Port: `5432`
- Database: `olist`
- User: `olist`
- Password: `olist`

## What Recruiters Should Notice

This project is designed to show more than query syntax. It demonstrates:

- business question framing
- validation of data grain before reporting
- awareness of join duplication risk
- creation of a reusable analytical layer
- readiness to move from SQL into dashboard development

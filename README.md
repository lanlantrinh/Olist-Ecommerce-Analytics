# Data Analytics Portfolio

This repository contains my data analytics projects, demonstrating end-to-end workflows from data engineering (using SQL and PostgreSQL) to business intelligence (Power BI).

## 1. Featured Projects

### Olist E-commerce Analytics (`/01_olist_ecommerce`)
An end-to-end analysis of 100,000+ transactions from the Brazilian marketplace Olist.

- **What it does:** Processes raw multi-table e-commerce data into a clean star schema database and provides an interactive Power BI dashboard suite (Executive, Logistics, and CX).
- **Why I used these technologies:** 
  - *PostgreSQL:* Used to safely aggregate data and prevent many-to-many join duplication via temporary CTEs.
  - *Power BI & DAX:* Selected for its VertiPaq engine, which optimizes time-intelligence metrics and allows dynamic cross-filtering between reviews and deliveries.
- **Challenges faced:** The raw dataset contained multiple items and payments per order. A standard direct join would falsely multiply total revenue. I solved this by pre-aggregating data via SQL before building the final analytical fact tables.

## 2. How to Install and Run

Each project folder contains its own isolated environment and setup scripts.
To run a specific project locally, navigate to its respective directory. For example:

\`\`\`bash
cd 01_olist_ecommerce
\`\`\`

Inside each project folder, you will find a dedicated `README.md` with detailed, step-by-step installation instructions (including Docker and Postgres setup).

## 3. How to Use The Projects

- **SQL Analysis:** All database schema, exploration scripts, and analytical views are stored in the `/sql` directory within each project folder.
- **Dashboards:** Final Power BI files (`.pbix`) can be opened directly to view the data models and interact with the reports. 

## 4. Credits

- **Data Source:** The original dataset is provided publicly by Olist via [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## 5. License

This project is licensed under the MIT License.

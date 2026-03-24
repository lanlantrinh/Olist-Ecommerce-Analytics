# Power BI Blueprint

This document is the build plan for the Power BI dashboard based on the PostgreSQL analytical layer in this project.

Note for macOS users:

- Power BI Desktop is a Windows application, so on a Mac you will typically need a Windows environment such as Parallels or another Windows machine to build the `.pbix` file.
- If you only want to view or share reports, the Power BI service in the browser can still be used after the report is created.

## Goal

Build a clean 3-page dashboard that answers the same business questions defined in the SQL analysis:

1. How does revenue change over time?
2. Which product categories generate the most revenue?
3. Do customers in certain states spend more?

## Data Source

Connect Power BI to the local PostgreSQL database and import only these views:

- `clean_orders`
- `clean_order_category_sales`

Avoid importing the raw transactional tables unless you need them later.

## Connection Settings

- Host: `localhost`
- Port: `5432`
- Database: `olist`
- User: `olist`
- Password: `olist`

## Recommended Model

Keep the model simple:

- `clean_orders` as the main order-level fact table
- `clean_order_category_sales` as the category-level fact table
- a `Date` table created in Power BI and related to:
  - `clean_orders[order_purchase_timestamp]`
  - `clean_order_category_sales[order_purchase_timestamp]`

If Power BI does not allow one date table to actively filter both facts in the way you want, keep the relationship active to `clean_orders` and use visuals carefully on the category page.

## Date Table

Create a date table in DAX:

```DAX
Date =
ADDCOLUMNS (
    CALENDAR ( DATE ( 2016, 9, 1 ), DATE ( 2018, 10, 31 ) ),
    "Year", YEAR ( [Date] ),
    "Month Number", MONTH ( [Date] ),
    "Month", FORMAT ( [Date], "MMM" ),
    "Year Month", FORMAT ( [Date], "YYYY-MM" ),
    "Quarter", "Q" & FORMAT ( [Date], "Q" )
)
```

Then sort `Date[Month]` by `Date[Month Number]` if needed.

## Core Measures

Create these measures first:

```DAX
Total Revenue = SUM ( clean_orders[total_payment] )

Total Orders = DISTINCTCOUNT ( clean_orders[order_id] )

Average Order Value = DIVIDE ( [Total Revenue], [Total Orders] )

Items Sold = SUM ( clean_order_category_sales[item_count] )

Category Revenue = SUM ( clean_order_category_sales[category_item_revenue] )
```

## Filtered Measures

To stay aligned with the SQL logic, exclude canceled and unavailable orders in the dashboard measures.

```DAX
Valid Revenue =
CALCULATE (
    [Total Revenue],
    clean_orders[has_payment] = TRUE (),
    NOT ( clean_orders[order_status] IN { "canceled", "unavailable" } )
)

Valid Orders =
CALCULATE (
    [Total Orders],
    clean_orders[has_payment] = TRUE (),
    NOT ( clean_orders[order_status] IN { "canceled", "unavailable" } )
)

Valid AOV = DIVIDE ( [Valid Revenue], [Valid Orders] )

Valid Category Revenue =
CALCULATE (
    [Category Revenue],
    NOT ( clean_order_category_sales[order_status] IN { "canceled", "unavailable" } )
)

Valid Items Sold =
CALCULATE (
    [Items Sold],
    NOT ( clean_order_category_sales[order_status] IN { "canceled", "unavailable" } )
)
```

## Page 1: Executive Overview

Purpose: show top-level performance at a glance.

Recommended visuals:

- KPI cards:
  - `Valid Revenue`
  - `Valid Orders`
  - `Valid AOV`
- Line chart:
  - Axis: `Date[Year Month]`
  - Values: `Valid Revenue`
- Column chart:
  - Axis: `Date[Year Month]`
  - Values: `Valid Orders`
- Donut or bar chart:
  - Axis: `clean_orders[order_status]`
  - Values: `Total Orders`

Recommended slicers:

- Year
- Month
- Customer state

## Page 2: Product Performance

Purpose: show which categories drive sales.

Recommended visuals:

- Bar chart:
  - Axis: `clean_order_category_sales[product_category_name]`
  - Values: `Valid Category Revenue`
  - Top N: 10
- Bar chart:
  - Axis: `clean_order_category_sales[product_category_name]`
  - Values: `Valid Items Sold`
  - Top N: 10
- Line chart:
  - Axis: `Date[Year Month]`
  - Values: `Valid Category Revenue`
- Matrix:
  - Rows: `product_category_name`
  - Values: `Valid Category Revenue`, `Valid Items Sold`

Recommended slicers:

- Product category
- Year
- Customer state

## Page 3: Geographic Analysis

Purpose: show where revenue comes from and how spending differs by state.

Recommended visuals:

- Filled map or bar chart:
  - Location/Axis: `clean_orders[customer_state]`
  - Values: `Valid Revenue`
- Bar chart:
  - Axis: `clean_orders[customer_state]`
  - Values: `Valid Orders`
- Bar chart:
  - Axis: `clean_orders[customer_state]`
  - Values: `Valid AOV`
- Table:
  - Columns: `customer_state`, `Valid Revenue`, `Valid Orders`, `Valid AOV`

Recommended slicers:

- Year
- Month

## Design Notes

Keep the dashboard clean and recruiter-friendly:

- use one accent color for revenue and one secondary color for volume
- format revenue as currency
- sort bar charts descending
- keep category names readable
- avoid overcrowding each page

## Story To Tell

When presenting the dashboard, emphasize this sequence:

1. Revenue trend over time
2. Which categories drive that revenue
3. Which states contribute the most revenue
4. Why the SQL model matters: order items and payments were aggregated before analysis to avoid double counting

## Final Deliverables

When the dashboard is complete, add these files to this folder:

- `olist_dashboard.pbix`
- 2 to 4 screenshot images
- a short `dashboard_notes.md` with the main findings

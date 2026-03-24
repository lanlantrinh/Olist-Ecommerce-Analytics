# Power BI Build Order

This guide is the shortest path from the finished SQL layer to a polished Power BI dashboard.

## First Decision: How You Will Build On Mac

Power BI Desktop is Windows-only. If you are working on a Mac, use one of these options:

1. Use a Windows laptop or desktop
2. Run Windows on your Mac with Parallels
3. Use a remote Windows machine

Best practical option for a portfolio project:

- build the `.pbix` in a Windows environment
- keep PostgreSQL running on the same Windows machine as Power BI if possible
- export screenshots and save the `.pbix` into this repo afterward

For this repo, the easiest setup is:

1. Clone the repo onto the Windows machine
2. Install Docker Desktop there
3. Run the Windows PowerShell scripts in [`scripts`](../scripts)
4. Connect Power BI to `localhost:5432`

## Step 1: Prepare The SQL Source

Before opening Power BI, make sure the PostgreSQL source is ready:

```bash
cd path/to/portfolio/01_olist_ecommerce
./scripts/db-init.sh
./scripts/load_olist_csvs.sh "/path/to/olist-csv-folder"
```

On Windows PowerShell:

```powershell
cd path\to\portfolio\01_olist_ecommerce
.\scripts\db-init.ps1
.\scripts\load_olist_csvs.ps1 "C:\path\to\olist-csv-folder"
```

The dashboard should use only these two views:

- `clean_orders`
- `clean_order_category_sales`

## Step 2: Connect Power BI To PostgreSQL

In Power BI Desktop:

1. Click `Get data`
2. Search for `PostgreSQL database`
3. Enter:
   - Server: `localhost:5432`
   - Database: `olist`
4. Choose `Import`
5. Sign in with:
   - Username: `olist`
   - Password: `olist`
6. Select only:
   - `clean_orders`
   - `clean_order_category_sales`
7. Click `Load`

## Step 3: Basic Model Cleanup

After loading:

1. Open `Model view`
2. Check that `order_purchase_timestamp` is typed as `Date/Time`
3. Confirm numeric fields are typed correctly:
   - `total_payment`
   - `total_item_value`
   - `total_freight`
   - `gross_order_value`
   - `category_item_revenue`
   - `category_freight_value`
4. Hide fields you will not use directly in visuals if the field list feels crowded

## Step 4: Create The Date Table

Go to `Modeling` -> `New table` and create:

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

Then:

1. Mark `Date` as a date table if needed
2. Sort `Date[Month]` by `Date[Month Number]`

## Step 5: Create Relationships

Recommended relationship setup:

1. Relate `Date[Date]` to `clean_orders[order_purchase_timestamp]`
2. Relate `Date[Date]` to `clean_order_category_sales[order_purchase_timestamp]`

If Power BI creates relationship issues because both fact tables connect to the same date table, keep the one that best supports your main page active first, then test visuals page by page.

## Step 6: Create Measures In This Order

Create a dedicated measure table if you want a cleaner model:

```DAX
Measures = { 1 }
```

Then create measures in this order:

```DAX
Total Revenue = SUM ( clean_orders[total_payment] )

Total Orders = DISTINCTCOUNT ( clean_orders[order_id] )

Average Order Value = DIVIDE ( [Total Revenue], [Total Orders] )

Items Sold = SUM ( clean_order_category_sales[item_count] )

Category Revenue = SUM ( clean_order_category_sales[category_item_revenue] )

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

## Step 7: Build Page 1 First

Page name: `Executive Overview`

Build these visuals first:

1. Card: `Valid Revenue`
2. Card: `Valid Orders`
3. Card: `Valid AOV`
4. Line chart:
   - Axis: `Date[Year Month]`
   - Values: `Valid Revenue`
5. Column chart:
   - Axis: `Date[Year Month]`
   - Values: `Valid Orders`
6. Bar chart:
   - Axis: `clean_orders[customer_state]`
   - Values: `Valid Revenue`
   - Top N: 10

Add slicers:

- `Date[Year]`
- `Date[Month]`
- `clean_orders[customer_state]`

If this page looks good, the rest of the dashboard usually becomes much easier.

## Step 8: Build Page 2

Page name: `Product Performance`

Build:

1. Bar chart:
   - Axis: `clean_order_category_sales[product_category_name]`
   - Values: `Valid Category Revenue`
   - Top N: 10
2. Bar chart:
   - Axis: `clean_order_category_sales[product_category_name]`
   - Values: `Valid Items Sold`
   - Top N: 10
3. Matrix:
   - Rows: `product_category_name`
   - Values: `Valid Category Revenue`, `Valid Items Sold`
4. Trend chart:
   - Axis: `Date[Year Month]`
   - Values: `Valid Category Revenue`

Add slicers:

- `Date[Year]`
- `clean_order_category_sales[product_category_name]`
- `clean_order_category_sales[customer_state]`

## Step 9: Build Page 3

Page name: `Geographic Analysis`

Build:

1. Bar chart:
   - Axis: `clean_orders[customer_state]`
   - Values: `Valid Revenue`
2. Bar chart:
   - Axis: `clean_orders[customer_state]`
   - Values: `Valid Orders`
3. Bar chart:
   - Axis: `clean_orders[customer_state]`
   - Values: `Valid AOV`
4. Table:
   - `customer_state`
   - `Valid Revenue`
   - `Valid Orders`
   - `Valid AOV`

If the map visual works well for you, you can replace one bar chart with a map. If not, bars are safer and usually easier to read.

## Step 10: Format For Recruiters

Aim for clarity before decoration.

Use these rules:

- keep one consistent title style across pages
- format revenue as currency
- sort category and state charts descending
- avoid more than 5 to 6 visuals per page
- use whitespace generously
- keep labels readable

Good page titles:

- Executive Overview
- Product Performance
- Geographic Analysis

## Step 11: Final Portfolio Package

When the dashboard is done:

1. Save the Power BI file as `olist_dashboard.pbix`
2. Export 2 to 4 screenshots
3. Fill in [`dashboard_notes_template.md`](./dashboard_notes_template.md)
4. Update the main project [`README.md`](../README.md) with the screenshots and 3 to 5 final insights

## Suggested Work Sequence

If you want the easiest order of work, do this:

1. Connect to PostgreSQL
2. Load the two views
3. Create the date table
4. Create the measures
5. Finish page 1
6. Finish page 2
7. Finish page 3
8. Clean formatting
9. Capture screenshots

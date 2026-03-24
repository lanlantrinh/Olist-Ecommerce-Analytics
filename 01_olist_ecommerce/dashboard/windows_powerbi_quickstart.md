# Windows Power BI Quickstart

Use this checklist when you move the project to a Windows machine for Power BI.

## 1. Install What You Need

Install these on the Windows machine:

- Git
- Docker Desktop
- Power BI Desktop

Optional but helpful:

- VS Code

## 2. Clone The Repo

Open PowerShell and run:

```powershell
git clone <your-repo-url>
cd path\to\portfolio\01_olist_ecommerce
```

## 3. Start PostgreSQL

Run:

```powershell
.\scripts\db-init.ps1
```

This starts the local PostgreSQL container and creates the schema and views.

## 4. Load The CSV Files

If the CSV files are already on the Windows machine, run:

```powershell
.\scripts\load_olist_csvs.ps1 "C:\path\to\olist-csv-folder"
```

If you copied the files into the project `data` folder already, run:

```powershell
.\scripts\load_olist_csvs.ps1
```

## 5. Open Power BI Desktop

Inside Power BI:

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

## 6. Build In This Order

Open [`powerbi_build_order.md`](./powerbi_build_order.md) and follow this sequence:

1. Create the `Date` table
2. Create the DAX measures
3. Build page 1: Executive Overview
4. Build page 2: Product Performance
5. Build page 3: Geographic Analysis

## 7. First DAX Measures To Paste

```DAX
Total Revenue = SUM ( clean_orders[total_payment] )

Total Orders = DISTINCTCOUNT ( clean_orders[order_id] )

Average Order Value = DIVIDE ( [Total Revenue], [Total Orders] )

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
```

## 8. First Page To Finish

If you only finish one page first, make it:

- `Executive Overview`

Put these visuals on it:

- Card: `Valid Revenue`
- Card: `Valid Orders`
- Card: `Valid AOV`
- Line chart: monthly revenue
- Column chart: monthly orders
- Bar chart: top 10 states by revenue

## 9. Files To Bring Back Into The Repo

After building the dashboard, add these back into the project:

- `olist_dashboard.pbix`
- dashboard screenshots
- completed dashboard notes

Use this template:

- [`dashboard_notes_template.md`](./dashboard_notes_template.md)

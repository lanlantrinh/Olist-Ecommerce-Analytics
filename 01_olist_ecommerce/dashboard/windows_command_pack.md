# Windows Command Pack

Use this file on the Windows machine if you want a simple copy-paste path to get the project running for Power BI.

## Option A: Git Works In PowerShell

If this command works:

```powershell
git --version
```

Then run:

```powershell
git clone https://github.com/lanlantrinh/portfolio.git
cd portfolio
git checkout olist-powerbi-prep
cd 01_olist_ecommerce
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\db-init.ps1
.\scripts\load_olist_csvs.ps1 "C:\olist-data"
```

## Option B: PowerShell Says "git is not recognized"

This means Git is either:

- not installed yet
- installed but not added to PATH

### Fastest workaround

Do this in the browser:

1. Open `https://github.com/lanlantrinh/portfolio`
2. Switch to branch `olist-powerbi-prep`
3. Click `Code`
4. Click `Download ZIP`
5. Extract the ZIP
6. Open PowerShell in the extracted `01_olist_ecommerce` folder

Then run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\db-init.ps1
.\scripts\load_olist_csvs.ps1 "C:\olist-data"
```

## If You Want Git To Work Properly

Install Git for Windows, then close and reopen PowerShell.

After that, test:

```powershell
git --version
```

If it prints a version number, use Option A from then on.

## CSV Files You Need In C:\olist-data

Put these files in `C:\olist-data`:

- `olist_customers_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_products_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`

## After The Commands Finish

Open Power BI Desktop and connect:

- Server: `localhost:5432`
- Database: `olist`
- Username: `olist`
- Password: `olist`

Load only:

- `clean_orders`
- `clean_order_category_sales`

Then follow:

- [`powerbi_build_order.md`](./powerbi_build_order.md)
- [`windows_powerbi_quickstart.md`](./windows_powerbi_quickstart.md)

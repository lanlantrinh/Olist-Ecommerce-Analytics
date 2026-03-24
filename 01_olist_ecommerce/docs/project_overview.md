# Project Overview

## Summary

This project analyzes Olist e-commerce sales data in PostgreSQL and prepares a clean reporting layer for Power BI. The emphasis is on trustworthy metrics, not just query output.

## Problem

The raw dataset contains multiple related tables at different grains:

- orders
- order items
- payments
- products
- customers

Without validating those relationships first, revenue can be double-counted when order items and payments are joined together.

## Approach

The project was completed in three stages:

1. Explore table grain, duplicates, and missing relationships
2. Build analytical views with safe aggregation logic
3. Answer core business questions with reusable SQL

## Important Data Decisions

- Use `orders` as the base grain for order-level metrics
- Aggregate `order_items` and `order_payments` before joining
- Use `payment_value` for order-level revenue
- Use item `price` for category-level revenue because payment values cannot be safely allocated across categories within mixed-category orders
- Exclude `canceled` and `unavailable` orders from revenue reporting

## Quality Findings

- 9,803 orders contain multiple items
- 2,961 orders contain multiple payment rows
- 275 orders would create many-to-many duplication risk if items and payments were joined directly
- 1 delivered order has items but no payment record
- No orphan rows were found in `order_items` or `order_payments`

## Outcome

The resulting SQL layer provides two dashboard-ready views:

- `clean_orders`
- `clean_order_category_sales`

These views support time-series revenue analysis, category performance analysis, and regional sales analysis in Power BI.

## Next Step

Build a Power BI dashboard using these views as the reporting source and document the final business insights with screenshots and commentary.

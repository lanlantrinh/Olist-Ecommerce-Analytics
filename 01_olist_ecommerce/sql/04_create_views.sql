-- Dashboard-friendly views
-- clean_orders = one row per order
-- clean_order_category_sales = one row per order + product category

CREATE OR REPLACE VIEW clean_orders AS
WITH item_agg AS (
    SELECT
        oi.order_id,
        COUNT(*) AS item_count,
        SUM(oi.price) AS total_item_value,
        SUM(oi.freight_value) AS total_freight
    FROM order_items oi
    GROUP BY oi.order_id
),
payment_agg AS (
    SELECT
        op.order_id,
        SUM(op.payment_value) AS total_payment
    FROM order_payments op
    GROUP BY op.order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp::timestamp AS order_purchase_timestamp,
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS purchase_month,
    c.customer_state,
    ia.item_count,
    ia.total_item_value,
    ia.total_freight,
    (COALESCE(ia.total_item_value, 0) + COALESCE(ia.total_freight, 0)) AS gross_order_value,
    pa.total_payment,
    (pa.total_payment IS NOT NULL) AS has_payment
FROM orders o
LEFT JOIN item_agg ia ON o.order_id = ia.order_id
LEFT JOIN payment_agg pa ON o.order_id = pa.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

CREATE OR REPLACE VIEW clean_order_category_sales AS
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::timestamp AS order_purchase_timestamp,
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS purchase_month,
    c.customer_state,
    COALESCE(p.product_category_name, 'unknown') AS product_category_name,
    COUNT(*) AS item_count,
    SUM(oi.price) AS category_item_revenue,
    SUM(oi.freight_value) AS category_freight_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
GROUP BY
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp::timestamp,
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp),
    c.customer_state,
    COALESCE(p.product_category_name, 'unknown');

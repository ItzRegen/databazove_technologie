# 1. --------------------------------------------
WITH ranked_orders AS (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.order_date DESC
        ) AS rn
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
)
SELECT
    customer_name,
    order_id,
    order_date
FROM ranked_orders
WHERE rn <= 2
ORDER BY customer_name, rn;
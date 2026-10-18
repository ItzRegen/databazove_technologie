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

# 2. --------------------------------------------
WITH customer_profit AS (
    SELECT
        c.customer_id,
        c.region,
        c.customer_name,
        SUM(o.profit) AS total_profit
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.region, c.customer_name
)
SELECT
    region,
    customer_name,
    total_profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS rank_profit,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS dense_rank_profit
FROM customer_profit
ORDER BY region, total_profit DESC;
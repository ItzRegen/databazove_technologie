# 1. --------------------------------------------
WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT
    sale_date,
    total_daily_sales
FROM daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;

# 2. --------------------------------------------
WITH category_sales AS (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT
    product_category,
    total_sales
FROM category_sales
ORDER BY total_sales DESC;

# 3. --------------------------------------------
WITH product_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT
        product_category,
        product_name,
        total_product_sales,
        RANK() OVER (
            PARTITION BY product_category
            ORDER BY total_product_sales DESC
        ) AS category_rank
    FROM product_sales
)
SELECT
    product_category,
    product_name,
    total_product_sales,
    category_rank
FROM ranked_products
WHERE category_rank <= 3
ORDER BY product_category, category_rank;

# 4. --------------------------------------------
WITH customer_revenue AS (
    SELECT
        customer_type,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_share AS (
    SELECT
        customer_type,
        revenue,
        SUM(revenue) OVER () AS total_revenue,
        ROUND(revenue * 100.0 / SUM(revenue) OVER (), 2) AS revenue_percentage
    FROM customer_revenue
)
SELECT
    customer_type,
    revenue,
    total_revenue,
    revenue_percentage
FROM revenue_share
ORDER BY revenue DESC;
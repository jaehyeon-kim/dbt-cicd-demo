WITH raw_orders AS (
  SELECT * FROM {{ source('raw', 'orders') }}
)
SELECT
  ROW_NUMBER() OVER() AS order_id,
  user_id,
  items,
  current_datetime() AS created_at
FROM raw_orders

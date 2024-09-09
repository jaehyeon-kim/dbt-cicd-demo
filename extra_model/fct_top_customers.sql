{{
  config(
    materialized = 'incremental'
  )
}}
WITH cte_items_expanced AS (
  SELECT 
    user.id AS user_id,
    user.first_name,
    user.last_name,
    p.quantity AS quantity,
    p.price AS price
  FROM {{ ref('fct_orders') }} AS o 
  CROSS JOIN UNNEST(product) AS p
  WHERE _PARTITIONTIME = (SELECT max(_PARTITIONTIME) FROM {{ ref('fct_orders') }})
)
SELECT
  user_id,
  first_name,
  last_name,
  sum(quantity) AS total_quantity,
  sum(price) AS total_price
FROM cte_items_expanced
GROUP BY user_id, first_name, last_name
ORDER BY sum(price) DESC
LIMIT 10
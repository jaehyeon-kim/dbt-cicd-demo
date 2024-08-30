WITH raw_products AS (
  SELECT * FROM {{ source('raw', 'products') }}
)
SELECT
  {{ dbt_utils.generate_surrogate_key(['name', 'description', 'price', 'category', 'image']) }} as product_key,
  ROW_NUMBER() OVER() AS product_id,
  name,
  description,
  price,
  category,
  image,
  current_datetime() AS created_at
FROM raw_products
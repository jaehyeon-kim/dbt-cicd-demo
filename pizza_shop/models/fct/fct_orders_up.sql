{{
  config(
    materialized = 'table'
  )
}}
SELECT * 
FROM {{ ref('fct_orders') }}
LIMIT 10
WITH raw_users AS (
  SELECT * FROM {{ source('raw', 'users') }}
)
SELECT
  {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'email', 'residence', 'lat', 'lon']) }} as user_key,
  ROW_NUMBER() OVER() AS user_id,
  first_name,
  last_name,
  email,
  residence,
  lat AS latitude,
  lon AS longitude,
  current_datetime() AS created_at
FROM raw_users
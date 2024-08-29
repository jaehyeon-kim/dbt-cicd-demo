FROM ghcr.io/dbt-labs/dbt-bigquery:1.8.2

COPY dbt_profiles dbt_profiles

COPY pizza_shop pizza_shop

RUN dbt deps --project-dir=pizza_shop

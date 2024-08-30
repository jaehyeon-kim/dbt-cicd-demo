FROM ghcr.io/dbt-labs/dbt-bigquery:1.8.2

ARG GCP_PROJECT_ID
ARG GCS_TARGET_PATH

ENV GCP_PROJECT_ID=${GCP_PROJECT_ID}
ENV GCS_TARGET_PATH=${GCS_TARGET_PATH}
ENV SA_KEYFILE=/usr/app/dbt/key.json
ENV DBT_ARTIFACT=/usr/app/dbt/pizza_shop/target/manifest.json

## set up gcloud
RUN apt-get update \
  && apt-get install -y curl \
  && curl -sSL https://sdk.cloud.google.com | bash

ENV PATH $PATH:/root/google-cloud-sdk/bin
COPY key.json key.json

## copy dbt source
COPY dbt_profiles dbt_profiles
COPY pizza_shop pizza_shop
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

RUN dbt deps --project-dir=pizza_shop

ENTRYPOINT ["./entrypoint.sh"]

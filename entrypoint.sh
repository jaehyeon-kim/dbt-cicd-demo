#!/bin/bash
set -e

# authenticate to GCP
gcloud auth activate-service-account \
  dbt-cicd@$GCP_PROJECT_ID.iam.gserviceaccount.com \
  --key-file $SA_KEYFILE --project $GCP_PROJECT_ID

# execute DBT with arguments from container launch
dbt "$@"

if [ -n "$GCS_TARGET_PATH" ]; then
    echo "source: $DBT_ARTIFACT, target: $GCS_TARGET_PATH"
    echo "Copying file..."
    gsutil --quiet cp $DBT_ARTIFACT $GCS_TARGET_PATH
fi

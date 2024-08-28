dbt debug --profiles-dir=config --project-dir=pizza_shop

dbt seed --profiles-dir=config --project-dir=pizza_shop --target dev
dbt run --profiles-dir=config --project-dir=pizza_shop --target dev

### dbt run
dbt run --profiles-dir=config --project-dir=pizza_shop --target ci \
  --select state:modified+ --defer --state prod-run-artifacts --debug

dbt test --profiles-dir=config --project-dir=pizza_shop --target ci \
  --select state:modified+ --defer --state prod-run-artifacts

### dbt clone
# clone all of my models from specified state to my target schema(s)
dbt clone --profiles-dir=config --project-dir=pizza_shop --target ci \
  --state prod-run-artifacts

dbt run --profiles-dir=config --project-dir=pizza_shop --target ci \
  --select state:modified+ --defer --state prod-run-artifacts

# clone all of my models from specified state to my target schema(s) 
# and recreate all pre-existing relations in the current target
dbt clone --profiles-dir=config --project-dir=pizza_shop --target ci \
  --state prod-run-artifacts --full-refresh
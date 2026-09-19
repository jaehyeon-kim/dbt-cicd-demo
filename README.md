# DBT CI/CD Demo with BigQuery and GitHub Actions

A single [dbt](https://www.getdbt.com/) project on [BigQuery](https://cloud.google.com/bigquery?hl=en) with two [GitHub Actions](https://github.com/features/actions) workflows that show how CI/CD can be set up for dbt. The project models a pizza shop: three source models, two slowly changing dimension models, one fact model, three seed CSV files and a set of unit tests. The repository is one build rather than a collection of separate examples, so the Docker image, the profiles and the dbt project are all used together by the workflows.

## Repository layout

| Path | What it holds |
|---|---|
| [.github/workflows](.github/workflows) | `slim-ci.yml` and `deploy.yml`, the two workflows described below |
| [pizza_shop](pizza_shop) | The dbt project: models, seeds, `schema.yml`, `sources.yml`, `unit_tests.yml` and `packages.yml` (`dbt_utils` 1.1.1) |
| [dbt_profiles](dbt_profiles) | `profiles.yml` with the `dev` and `ci` BigQuery targets, both reading `GCP_PROJECT_ID`, `SA_KEYFILE` and `CI_DATASET` from the environment |

The root `Dockerfile` copies `dbt_profiles`, `pizza_shop` and `entrypoint.sh` into an image based on `ghcr.io/dbt-labs/dbt-bigquery:1.8.2`. `entrypoint.sh` authenticates to Google Cloud, runs `dbt` with whatever arguments the container is given, and then copies `pizza_shop/target/manifest.json` to Cloud Storage so the next slim CI run has a state to compare against.

## Workflows

The CI/CD process has two workflows - `slim-ci` and `deploy`. When a pull request is created to the main branch, the `slim-ci` workflow is triggered, and it aims to perform tests after building only modified models and its first-order children in a _ci_ dataset. Thanks to the [defer feature](https://docs.getdbt.com/reference/node-selection/defer) and [state method](https://docs.getdbt.com/reference/node-selection/methods#the-state-method), it saves time and computational resources for testing a few models in a _dbt_ project. When a pull request is merged to the main branch, the `deploy` workflow is triggered. It begins with performing [unit tests](https://docs.getdbt.com/docs/build/unit-tests) to validate key SQL modelling logic on a small set of static inputs. Once the tests are complete successfully, two jobs are triggered concurrently. The first job builds a Docker container that packages the _dbt_ model and pushes into _Artifact Registry_ while the second one publishes the project documentation into _GitHub Pages_.

## How the workflows run here

Both automatic triggers are commented out in the workflow files. `slim-ci.yml` has its `pull_request` trigger commented out and `deploy.yml` has its `push` trigger commented out, so `workflow_dispatch` is the only trigger left in either file. Neither workflow runs on a push or a pull request. They only run when someone starts them by hand from the Actions tab. The published dbt documentation at <https://jaehyeon.me/dbt-cicd-demo/> therefore only changes when `deploy` is started by hand.

Both workflows write the `GCP_SA_KEY` secret to `.github/key.json`. The `deploy` workflow then copies that file to the repository root before `docker build`, and the `Dockerfile` runs `COPY key.json key.json`, so the service account key ends up inside the published image. This is a demonstration of the CI/CD flow, not a pattern to copy. A real pipeline should keep the key out of the image and use workload identity federation or a runtime secret instead.

## Posts

- [DBT CI/CD Demo with BigQuery and GitHub Actions](https://jaehyeon.me/blog/2024-09-05-dbt-cicd-demo/)
- [Guide to Running DBT in Production](https://jaehyeon.me/blog/2024-09-13-dbt-guide/), which uses the `release-lifecycle` branch of this repository rather than `main`. That branch adds `prod` and `clone` targets to `dbt_profiles/profiles.yml` and an `extra_models` directory.

![](images/featured.png#center)

## License

MIT. See [LICENSE](LICENSE).

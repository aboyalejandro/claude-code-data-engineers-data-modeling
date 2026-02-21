## Project

marketing_analytics dbt project (PostgreSQL). Work on a new branch from `main`.

## dbt Conventions

- **Staging:** `stg_` prefix, one model per source table, minimal transformation
- **Intermediate:** `int_` prefix, business logic aggregations
- **Marts:** No prefix, documented with schema YAML
- **SQL patterns:** Descriptive CTE names, `final` CTE, `COALESCE` on nullable joins, `::float` casting for division
- **Tests:** `not_null`/`unique` on primary keys
- **Run commands:** Always use `--profiles-dir . --project-dir .` flags

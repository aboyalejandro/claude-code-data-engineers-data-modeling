---
name: team-conventions
description: Encode the marketing_analytics team's dbt naming conventions, SQL style, and documentation standards. Claude MUST follow these conventions when generating or modifying any dbt model in this project.
---

# Team Conventions for marketing_analytics

Enforces team-specific dbt standards automatically when generating or editing models.

## Naming Conventions

### Model Prefixes
- **Staging:** `stg_` prefix — one model per source table, minimal transformation (renaming, type casting, simple CASE statements)
- **Intermediate:** `int_` prefix — business logic aggregations, joins across staging models. Always document the grain and upstream dependencies in a SQL comment at the top
- **Marts:** No prefix — public-facing analytics tables. Full column documentation required

### Column Naming
- All columns use `snake_case`
- Aggregates: `total_*` for sums, `count_*` for counts, `avg_*` for averages
- Foreign keys: explicit names like `campaign_id`, `user_id` (not `id` or `fk_campaign`)
- Booleans: `is_*` or `has_*` prefix
- Dates: `*_date` suffix for dates, `*_at` suffix for timestamps

## SQL Style

### Calculations
- Always cast to `::float` before division to avoid integer truncation
- Wrap nullable aggregates in `COALESCE(value, 0)` when used in joins or downstream calculations
- Use `NULLIF(denominator, 0)` to prevent division-by-zero errors
- Window functions for relative positioning (percentiles, rankings)

### CTEs
- Use descriptive CTE names matching the source model name (e.g., `sessions`, `conversions`)
- Always end with a `final` CTE that produces the output
- One CTE per logical step — no deeply nested subqueries

### General
- Explicit column lists in SELECT (no `SELECT *` in intermediate or marts)
- Trailing commas in column lists
- `{{ ref('model_name') }}` for all model references
- `{{ source('schema', 'table') }}` for raw sources (staging only)

## Documentation Standards

### Schema YAML
- Every model gets a `_schema.yml` entry (or is added to the layer's existing schema file)
- Column descriptions are required for all columns
- `not_null` test on primary keys and foreign keys
- `unique` test on primary keys
- Model description includes: purpose, grain, and upstream dependencies

### SQL Comments
- Intermediate and mart models start with a comment block describing purpose and upstream models
- No inline comments unless the logic is non-obvious

## Materialization
- All models materialize as `view` (configured in `dbt_project.yml`)
- No model-level materialization overrides unless explicitly discussed

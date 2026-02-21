# Stage 3 — Modeling: dbt Implementation

> Once the ERD is approved on Miro, Claude generates the dbt models, schema docs, and tests — then validates everything compiles and passes.

## What happens in this stage

1. **Generate models** — Claude creates the new dbt models following project conventions (`stg_` for staging, `int_` for intermediate, marts with no prefix).
2. **Add schema YAMLs** — Each model gets documented with column descriptions, `not_null`/`unique` tests on primary keys.
3. **Compile & test** — Claude runs `dbt compile` and `dbt test` with `--profiles-dir . --project-dir .` to validate everything works.
4. **Review** — The finished models land on the `complete` branch for comparison.

## Screenshots

> Add screenshots here as the workflow is executed:
>
> - `01-model-generation.png` — Claude writing the SQL models
> - `02-schema-yaml.png` — Generated schema documentation
> - `03-dbt-compile.png` — Successful compilation
> - `04-dbt-test.png` — All tests passing

## Models created from the PRD

| Model | Layer | Purpose |
|-------|-------|---------|
| `int_customer_lifetime_value` | Intermediate | Revenue, order count, first/last purchase per customer |
| `customer_lifetime_value` | Mart | Adds acquisition channel, LTV segmentation (high/medium/low) |
| `int_campaign_funnel` | Intermediate | Impressions, clicks, sessions, conversions per campaign |
| `campaign_funnel_analysis` | Mart | Stage-to-stage conversion rates, efficiency score |

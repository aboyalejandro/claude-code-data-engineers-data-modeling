## Project

marketing_analytics dbt project (PostgreSQL). Extends an existing base with new models generated from a business PRD.

## Tool Stack

### Miro MCP
- `miro__context_explore` — Overview of board structure (frames, documents, tables)
- `miro__board_list_items` — List items by type (`sticky_note` for requirements, `item_type` filter)
- `miro__context_get` — Extract text from specific board items
- `miro__diagram_get_dsl` — Get DSL format for `entity_relationship` diagrams before creating
- `miro__diagram_create` — Create ERD on board from DSL

### MCP Data Toolbox (postgres)
Configured in `.mcp.json`. Connects to the PostgreSQL warehouse for schema discovery, sampling, and exploratory queries.

### dbt Agent Skills
Installed via `/plugin marketplace add dbt-labs/dbt-agent-skills` + `/plugin install dbt@dbt-agent-marketplace`. Skills auto-activate on matching prompts:
- `using-dbt-for-analytics-engineering` — Model generation, debugging, source exploration
- `running-dbt-commands` — CLI execution with correct flags
- `fetching-dbt-docs` — Documentation lookups

### Custom Skill: prd-to-dbt
Located at `.claude/skills/prd-to-dbt/SKILL.md`. Translates business requirements into a dbt implementation plan. Reads Miro board + explores database + reads existing schema YAMLs, then maps business concepts to models.

## dbt Conventions

- **Staging:** `stg_` prefix, one model per source table, minimal transformation
- **Intermediate:** `int_` prefix, business logic aggregations
- **Marts:** No prefix, documented with schema YAML
- **SQL patterns:** Descriptive CTE names, `final` CTE, `COALESCE` on nullable joins, `::float` casting for division
- **Tests:** `not_null`/`unique` on primary keys

## Running dbt

```bash
docker compose up -d postgresql && docker compose up seed
docker compose run --rm dbt dbt compile --profiles-dir . --project-dir .
docker compose run --rm dbt dbt test --profiles-dir . --project-dir .
```

## Workflow

1. Read PRD from Miro (`miro__board_list_items` + `miro__context_get`)
2. Explore database via MCP Data Toolbox
3. Run `prd-to-dbt` Skill to produce implementation plan
4. Propose ERD on Miro (`miro__diagram_create` with `entity_relationship`)
5. Implement with dbt Agent Skills after approval
6. Validate with `dbt compile` + `dbt test`

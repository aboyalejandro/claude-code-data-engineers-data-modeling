## Project

marketing_analytics dbt project (PostgreSQL). Base project on `main`, full implementation on `complete` branch.

## dbt Conventions

- **Staging:** `stg_` prefix, one model per source table, minimal transformation
- **Intermediate:** `int_` prefix, business logic aggregations
- **Marts:** No prefix, documented with schema YAML
- **SQL patterns:** Descriptive CTE names, `final` CTE, `COALESCE` on nullable joins, `::float` casting for division
- **Tests:** `not_null`/`unique` on primary keys
- **Run commands:** Always use `--profiles-dir . --project-dir .` flags

## Miro MCP Tool Reference

- `miro__context_explore` — Board structure overview (frames, documents, tables)
- `miro__board_list_items` — List items by type (`sticky_note` for requirements)
- `miro__context_get` — Extract text from specific board items
- `miro__diagram_get_dsl` — Get DSL format for `entity_relationship` diagrams
- `miro__diagram_create` — Create ERD on board from DSL

## Custom Skill: prd-to-dbt

Located at `.claude/skills/prd-to-dbt/SKILL.md`. Translates business requirements into a dbt implementation plan. Reads Miro board + explores database + reads existing schema YAMLs, then maps business concepts to models.

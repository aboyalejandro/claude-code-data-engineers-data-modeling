---
name: prd-to-dbt
description: Translate business requirements into a dbt implementation plan by reading a Miro board, exploring the database, and mapping against the existing project's sources and schema YAMLs. Triggers include "translate this PRD", "what models do we need", "plan the implementation", or when a Miro board URL is provided.
---

# PRD to dbt Implementation Translator

Reads business requirements from Miro, explores the database, and maps against the existing dbt project to produce a technical implementation plan.

## How It Works

### 1. Read business requirements from Miro

Use Miro MCP to extract requirements from the board:

- `miro__context_explore` with the board URL to get an overview of frames, documents, and high-level structure
- `miro__board_list_items` with `item_type: sticky_note` to extract all sticky notes (business requirements are usually here)
- `miro__context_get` on specific items (documents, frames) for detailed text extraction

Requirements are in business language, not technical specs. Extract them as-is.

### 2. Explore the database

Use MCP Data Toolbox (postgres) to understand what raw data is available:

- List tables and columns in the warehouse schema
- Sample rows to understand data shape, value distributions, and nullability
- Run exploratory queries to validate assumptions (e.g., are there multiple purchases per user? What channels exist?)

### 3. Read existing project schema

Scan the dbt project to understand what's already modeled:

- `_sources.yml` — What raw tables are defined and their columns
- Existing staging/intermediate/mart models — What's already built, to avoid duplication
- `dbt_project.yml` — Materialization settings and naming patterns

### 4. Map business concepts to data

For each business requirement:

- Identify which source tables and existing models contain the relevant data
- Determine what new models are needed (staging, intermediate, marts)
- Define the grain of each new model
- Specify joins and aggregation logic
- Flag any gaps where the existing data can't satisfy a requirement

### 5. Produce implementation plan

Output a structured plan:

```
## Implementation Plan

### New Staging Models
- `stg_X` — [purpose, source table, grain]

### New Intermediate Models
- `int_X` — [purpose, upstream models, grain, key logic]

### New Mart Models
- `model_name` — [purpose, upstream models, grain, business question it answers]

### Gaps / Open Questions
- [anything the business requirements ask for that the existing data can't support]
```

### 6. Propose ERD on Miro

After the plan is reviewed, use Miro MCP to push the proposed schema back to the board:

- `miro__diagram_get_dsl` with `diagram_type: entity_relationship` to get the DSL format
- `miro__diagram_create` with the ERD DSL showing proposed models, their relationships, and key columns

This gives stakeholders a visual to approve before implementation.

## Important

- Never invent source tables that don't exist in `_sources.yml`
- Match the SQL style of existing models (check for CTE naming, COALESCE patterns, casting)
- The plan is for discussion before implementation — don't generate SQL yet

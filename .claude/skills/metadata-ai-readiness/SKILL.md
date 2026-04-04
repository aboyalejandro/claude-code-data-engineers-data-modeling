---
name: metadata-ai-readiness
description: Audit and enrich dbt mart models for AI consumption. Applies dbt Agent Skills' writing-documentation standards as audit criteria and automates the discovering-data methodology via Postgres MCP. Writes enriched descriptions back to dbt YAML. Triggers include "ai readiness", "is this model ready", "enrich", "audit yaml", "pre-merge check".
---

# AI Readiness

Automates the standards defined in dbt Agent Skills' `writing-documentation` and `discovering-data` references. Applies them as an audit checklist and runs the data profiling via Postgres MCP so you don't have to do it table by table.

## How It Works

1. **Parse `$ARGUMENTS`** — Model name (e.g. `campaign_performance`), or `all`/empty for all mart models.
2. **dbt schema audit** — Apply `writing-documentation` as a checklist. Read `dbt/models/marts/{model}.sql` + `dbt/models/marts/_marts.yml`. Check:
   - Model has a description
   - All SQL columns are present in YAML
   - Descriptions say something beyond the column name (flag any that merely restate it)
   - Grain columns have `not_null` + `unique` tests
3. **Query the database** — Automate the `discovering-data` 6-step methodology via Postgres MCP against `localhost:5432`:
   - **Grain validation**: `SELECT COUNT(*), COUNT(DISTINCT {grain_columns}) FROM {model}` — confirm declared grain holds
   - **Column profiling**: NULLs %, min/max, distinct counts on every metric column
   - **Edge case discovery**: zeros vs NULLs (COALESCEd columns behave differently from NULLIFed columns), skewed distributions, date gaps
   - **Example queries**: 2-3 queries demonstrating how to use the model for common business questions
   - All findings become candidates for `[Known Issues / Caveats]` entries
4. **Report** — Pass/fail checklist per model with 2 sections: **dbt Schema** + **Query Guidance**. End with `PASS: X/Y | Auto-fixable: N | Manual: N`.
5. **Offer fixes** — Propose changes, confirm with user, edit `_marts.yml`:
   - **Can fix**: missing/thin descriptions (model + columns), missing column YAML entries
   - **Cannot fix** (flag only): missing dbt tests (print snippet for user to add)

## Description Format

Plain text with bracketed headers (no markdown, dbt YAML renders plain text).

**Tables**:
`[Business Purpose]` what business questions it answers and why it exists.
`[How It's Used]` who consumes it and what decisions it drives.
`[Data Grain]` one row = what. Source lineage (which staging/intermediate models feed it).
`[Known Issues / Caveats]` exclusions, NULLs, COALESCEs, edge cases found in profiling.

**Columns**:
`[Business Purpose]` what the value represents. Never restate the column name.
`[Known Issues / Caveats]` only when real caveats exist; skip if none found.

## Reference

**Mart models**: `campaign_performance`, `daily_summary`
**Files**: SQL at `dbt/models/marts/{model}.sql`, YAML at `dbt/models/marts/_marts.yml`
**Upstream**: trace `{{ ref('...') }}` calls in SQL to find source models

**Grain map**:
- `campaign_performance` → composite: `campaign_id` + `date`
- `daily_summary` → single: `date`

**dbt Agent Skills standards this skill automates**:
- `writing-documentation` — "Never generate documentation which simply restates the entity's name. Describe why, not just what."
- `discovering-data` — 6-step methodology: inventory, sample, grain check, profile, validate relationships, document findings.

## Output Format

Checklist per model with 2 sections:

**dbt Schema** (description exists, all SQL columns in YAML, descriptions pass writing-documentation check, grain columns have tests)

**Query Guidance** (grain holds, column profiles, edge cases found, example queries)

End with: `PASS: X/Y | Auto-fixable: N | Manual: N`
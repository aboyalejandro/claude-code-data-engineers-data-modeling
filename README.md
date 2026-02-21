# agentic-miro-to-dbt

Companion repo for [From Miro to dbt: Data Modeling with MCPs and Skills](https://thepipeandtheline.substack.com).

Go from a business PRD on a Miro board to documented dbt models in one Claude Code session.

## Stack

- **[Miro MCP](https://github.com/miroapp/miro-ai)** — Read business requirements, push ERDs for approval
- **[MCP Data Toolbox](https://github.com/googleapis/genai-toolbox)** — Database exploration (schema discovery, sample data, queries)
- **[dbt Agent Skills](https://github.com/dbt-labs/dbt-agent-skills)** — Model generation with dbt best practices
- **Custom Skill: `prd-to-dbt`** — Translates business language → technical implementation plan

## How to Run

```bash
# Start PostgreSQL and seed synthetic marketing data
docker compose up -d postgresql
docker compose up seed

# Run dbt
docker compose run --rm dbt dbt compile --profiles-dir . --project-dir .
docker compose run --rm dbt dbt test --profiles-dir . --project-dir .
```

Configure MCPs and Skills:

```bash
# Miro MCP (or use the .mcp.json already included)
claude mcp add --transport http miro https://mcp.miro.com/

# dbt Agent Skills
/plugin marketplace add dbt-labs/dbt-agent-skills
/plugin install dbt@dbt-agent-marketplace
```

Configure [MCP Data Toolbox](https://github.com/googleapis/genai-toolbox) for your warehouse (see `.mcp.json` for the config template).

## The Workflow

1. **Read PRD + explore database** — Miro MCP extracts requirements, Data Toolbox explores raw tables
2. **Translate to plan** — `prd-to-dbt` Skill maps business concepts to models, columns, joins
3. **Propose schema on Miro** — ERD on the board for stakeholder approval
4. **Implement & Validate** — dbt Agent Skills generate models with schema docs and tests. Then run `dbt compile` + `dbt test`

## Project Structure

```
.claude/skills/prd-to-dbt/   # Custom translation Skill
seed/                         # S3 → PostgreSQL data loader
dbt/                          # marketing_analytics dbt project
  models/
    staging/                  # 5 staging models (1 new from PRD)
    intermediate/             # 8 intermediate models (2 new from PRD)
    marts/                    # 6 marts (2 new from PRD)
```
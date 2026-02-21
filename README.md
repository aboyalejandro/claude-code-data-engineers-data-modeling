# agentic-miro-to-dbt

Companion repo for [Claude Code for Data Engineer: MCP Driven Data Modeling with dbt & Miro & PostgreSQL](https://thepipeandtheline.substack.com).

Go from a business PRD on a Miro board to documented dbt models in one Claude Code session.

## Branches

- **`main`** — Starting point. Base project with campaigns, sessions, and conversions already modeled. The PRD exists but nothing from it has been implemented yet. This is where you run the workflow.
- **`complete`** — Finished reference. All PRD-generated models (CLV, funnel analysis, user journey, channel attribution) are built out. Use this to see the expected end state.

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

### Postgres MCP (Google GenAI Toolbox)

The `.mcp.json` is pre-configured for the Docker PostgreSQL instance. You just need the toolbox binary:

```bash
# macOS ARM64 (Apple Silicon)
curl -O https://storage.googleapis.com/genai-toolbox/v0.7.0/darwin/arm64/toolbox
chmod +x toolbox && mkdir -p bin && mv toolbox bin/

# macOS Intel
curl -O https://storage.googleapis.com/genai-toolbox/v0.7.0/darwin/amd64/toolbox
chmod +x toolbox && mkdir -p bin && mv toolbox bin/

# Linux x86_64
curl -O https://storage.googleapis.com/genai-toolbox/v0.7.0/linux/amd64/toolbox
chmod +x toolbox && mkdir -p bin && mv toolbox bin/
```

### Other MCPs and Skills

```bash
# Miro MCP (or use the .mcp.json already included)
claude mcp add --transport http miro https://mcp.miro.com/

# dbt Agent Skills
/plugin marketplace add dbt-labs/dbt-agent-skills
/plugin install dbt@dbt-agent-marketplace
```

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
    staging/                  # 4 staging models
    marts/                    # 2 marts (campaign_performance, daily_summary)
docs/
  sample-prd.md               # Business PRD for CLV + Funnel Analysis
```

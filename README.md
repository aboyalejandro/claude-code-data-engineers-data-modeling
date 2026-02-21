# 🔄 Claude Code for Data Engineers: MCP Driven Data Modeling with dbt & Miro & PostgreSQL

Go from a business PRD on a Miro board to documented dbt models in one Claude Code session.

All context in this post: [Claude Code for Data Engineer: MCP Driven Data Modeling with dbt & Miro & PostgreSQL](https://thepipeandtheline.substack.com)

## 🧩 Stack

- **[Miro MCP](https://github.com/miroapp/miro-ai)** — Read business requirements, push ERDs for approval
- **[MCP Data Toolbox](https://github.com/googleapis/genai-toolbox)** — Database exploration (schema discovery, sample data, queries)
- **[dbt Agent Skills](https://github.com/dbt-labs/dbt-agent-skills)** — Model generation with dbt best practices
- **Custom Skill: `prd-to-dbt`** — Translates business language → technical implementation plan

## 🌿 Branches

- **`main`** — Starting point. Base dbt project with campaigns, sessions, and conversions modeled. The [PRD lives on Miro](https://miro.com/app/board/uXjVGAWWNk0=/?share_link_id=558250594311) but nothing from it has been implemented yet. Run the workflow here.
- **[PR #1](https://github.com/aboyalejandro/claude-code-data-engineers-data-modeling/pull/1)** — Full implementation: 2 intermediate + 2 new mart models generated from the PRD.

## ⚡ Quick Start

```bash
# 1. Start PostgreSQL and seed synthetic marketing data
docker compose up -d postgresql
docker compose up seed

# 2. Run dbt
docker compose run --rm dbt dbt compile --profiles-dir . --project-dir .
docker compose run --rm dbt dbt test --profiles-dir . --project-dir .
```

### Postgres MCP (Google GenAI Toolbox)

The `.mcp.json` is pre-configured for the Docker PostgreSQL instance. Download the toolbox binary:

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

### Miro MCP & dbt Agent Skills

Miro MCP is pre-configured in `.mcp.json`. On first use, Claude will prompt you to authenticate via browser.

```bash
# dbt Agent Skills
/plugin marketplace add dbt-labs/dbt-agent-skills
/plugin install dbt@dbt-agent-marketplace
```

## 🔄 The Workflow

1. **Read PRD + explore database** — Miro MCP extracts requirements, Data Toolbox explores raw tables
2. **Translate to plan** — Custom Skill maps business concepts to models, columns, joins
3. **Propose schema on Miro** — ERD on the board for stakeholder approval
4. **Implement & validate** — dbt Agent Skills generate models with schema docs and tests

## 🗺️ Sitemap

```text
workflow/                          # Full demo walkthrough
  DEMO.md                          #   Master guide — start here
  setup/                           #   Stage 1: Connect tools
    SETUP.md                       #     Master setup guide
    miro/                          #     Miro MCP connection + screenshots
    dbt/                           #     dbt Agent Skills install + screenshots
  design/                          #   Stage 2: Read PRD + propose ERD
    DESIGN.md                      #     Schema design walkthrough
  modeling/                        #   Stage 3: Implement dbt models
    MODELING.md                    #     dbt implementation walkthrough

.claude/skills/prd-to-dbt/        # Custom translation Skill
seed/                              # S3 → PostgreSQL data loader
dbt/                               # marketing_analytics dbt project
  models/
    staging/                       #   4 staging models
    intermediate/                  #   2 intermediate models (int_customer_lifetime_value, int_campaign_funnel)
    marts/                         #   4 marts (campaign_performance, daily_summary, customer_lifetime_value, campaign_funnel_analysis)
```

The business PRD lives on [this Miro board](https://miro.com/app/board/uXjVGAWWNk0=/?share_link_id=558250594311) — Claude reads it directly via Miro MCP during the workflow.

**Follow the demo:** [`workflow/DEMO.md`](workflow/DEMO.md)

### 📩 Subscribe to [The Pipe & The Line](https://thepipeandtheline.substack.com)

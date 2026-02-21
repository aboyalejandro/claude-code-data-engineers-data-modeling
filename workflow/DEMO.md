# Demo: From PRD to dbt Models in One Session

End-to-end walkthrough of the Miro-to-dbt workflow using Claude Code with MCP tools.

**Miro board:** [Customer Insights for Marketing](https://miro.com/app/board/uXjVGAWWNk0=/?share_link_id=558250594311)

---

## Stage 1 — [Setup: Connecting Miro MCP](setup/MIRO_MCP_SETUP.md)

Connect Claude Code to your Miro board via the MCP server. One-time OAuth flow.

| Step | Screenshot |
|------|-----------|
| `/mcp` shows Miro needs auth | ![](setup/01-mcp-needs-auth.png) |
| Select "Authenticate" | ![](setup/02-mcp-authenticate.png) |
| Browser opens for OAuth | ![](setup/03-browser-opens.png) |
| Allow access | ![](setup/04-allow-access.png) |
| Select team & confirm | ![](setup/05-select-team.png) |

**Result:** `Authentication successful. Connected to miro.`

---

## Stage 2 — [Design: Schema on Miro](design/DESIGN.md)

Claude reads the PRD directly from the [Miro board](https://miro.com/app/board/uXjVGAWWNk0=/?share_link_id=558250594311), explores the database, and proposes an ERD back on Miro for stakeholder approval.

1. Extract requirements via `context_explore` + `context_get`
2. Discover existing tables via Postgres MCP
3. Run `prd-to-dbt` skill to translate business concepts to models
4. Push ERD to the board via `diagram_create`

> Screenshots for this stage are added as the workflow runs — see [DESIGN.md](design/DESIGN.md).

---

## Stage 3 — [Modeling: dbt Implementation](modeling/MODELING.md)

Once the ERD is approved, Claude generates the dbt models, schema docs, and tests.

1. Create staging/intermediate/mart models following project conventions
2. Add schema YAMLs with column docs and tests
3. Run `dbt compile` + `dbt test` to validate

| Model | Layer | What it answers |
|-------|-------|----------------|
| `int_customer_lifetime_value` | Intermediate | Revenue + orders per customer |
| `customer_lifetime_value` | Mart | LTV with channel and segmentation |
| `int_campaign_funnel` | Intermediate | Funnel metrics per campaign |
| `campaign_funnel_analysis` | Mart | Conversion rates + efficiency score |

> Screenshots for this stage are added as the workflow runs — see [MODELING.md](modeling/MODELING.md).

---

## Folder Structure

```
workflow/
  DEMO.md              ← you are here
  setup/
    MIRO_MCP_SETUP.md  ← Miro MCP connection guide
    01-05 *.png        ← setup screenshots
  design/
    DESIGN.md          ← schema design stage
  modeling/
    MODELING.md         ← dbt implementation stage
```

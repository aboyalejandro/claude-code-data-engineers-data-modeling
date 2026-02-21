# Stage 1 — Setup

Before running the workflow, connect two tool integrations to Claude Code.

## Miro MCP

The Miro MCP server is pre-configured in `.mcp.json`. Run `/mcp` inside Claude Code, select the Miro server, and authenticate via OAuth.

| Step | Screenshot |
|------|-----------|
| `/mcp` shows Miro needs auth | ![mcp status](miro/01-mcp-needs-auth.png) |
| Select "Authenticate" | ![authenticate](miro/02-mcp-authenticate.png) |
| Browser opens for OAuth | ![browser oauth](miro/03-browser-opens.png) |
| Allow access | ![allow access](miro/04-allow-access.png) |
| Select team & confirm | ![select team](miro/05-select-team.png) |

**Result:** `Authentication successful. Connected to miro.`

---

## dbt Agent Skills

Plugin marketplace skills that give Claude Code dbt-specific knowledge for building models, running commands, and writing tests. Used in Stage 3 (Modeling).

| Step | Screenshot |
|------|-----------|
| Add `dbt-labs/dbt-agent-skills` marketplace | ![add marketplace](dbt/01-plugin-marketplaces.png) |
| Enter marketplace source | ![marketplace source](dbt/02-add-marketplace.png) |
| Discover dbt plugin | ![discover plugin](dbt/03-discover-dbt-plugin.png) |
| Install at project scope | ![install plugin](dbt/04-install-project-scope.png) |

**Result:** dbt skills available for the modeling stage.

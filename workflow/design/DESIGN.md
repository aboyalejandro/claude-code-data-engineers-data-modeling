# Stage 2 — Design: Schema on Miro

> After connecting the MCP tools, Claude reads the PRD from the Miro board, explores the database, and proposes an ERD back on the board for review.

## What happens in this stage

1. **Read the PRD** — Claude uses `context_explore` and `context_get` to extract the business requirements from sticky notes and documents on the Miro board.
2. **Explore the database** — Using the Postgres MCP, Claude discovers existing tables (`campaigns`, `sessions`, `conversions`, `users`) and samples data to understand the schema.
3. **Translate to plan** — The `prd-to-dbt` skill maps business concepts (customer lifetime value, funnel drop-off) to concrete dbt models, columns, and joins.
4. **Propose ERD on Miro** — Claude uses `diagram_create` to push an entity-relationship diagram onto the board so stakeholders can review and approve before any code is written.

## Screenshots

### 1. Read PRD from the Miro board

Claude uses `context_explore` to discover the board structure, then `context_get` to extract the full PRD content — all via MCP, no copy-paste needed.

![Reading PRD from Miro board](01-read-prd-from-board.png)

> Remaining screenshots to add as the workflow continues:
>
> - `02-explore-database.png` — Claude discovering existing tables
> - `03-implementation-plan.png` — The generated translation plan
> - `04-erd-on-miro.png` — The proposed ERD pushed to the board

## Key files

- [Miro board](https://miro.com/app/board/uXjVGAWWNk0=/?share_link_id=558250594311) — The PRD lives directly on the board (Claude reads it via MCP)
- `.claude/skills/prd-to-dbt/SKILL.md` — The custom skill that drives the translation

# Connecting Miro MCP to Claude Code

This guide walks you through authenticating the Miro MCP server so Claude Code can read and write to your Miro boards.

## Step 1 — Check MCP status

Run `/mcp` inside Claude Code. You'll see the Miro server listed under **Project MCPs** with a warning: **needs authentication**.

![MCP needs authentication](01-mcp-needs-auth.png)

## Step 2 — Start authentication

Select the Miro server and choose **1. Authenticate**.

![Select Authenticate](02-mcp-authenticate.png)

## Step 3 — Browser opens for OAuth

Claude Code will open a browser window automatically. If it doesn't, copy the URL shown in the terminal and paste it into your browser.

![Browser URL for auth](03-browser-opens.png)

## Step 4 — Allow access

In the browser, you'll see an **Application Access Request** from Claude Code (miro) to the Miro MCP server. Click **Allow Access**.

![Allow Access dialog](04-allow-access.png)

## Step 5 — Select your team

Choose the Miro team you want to connect and confirm. This grants Claude Code read and write access to boards in that team.

![Select a team](05-select-team.png)

## Done

Back in Claude Code, you'll see: `Authentication successful. Connected to miro.`

This gives you access to the following Miro MCP tools:

| Tool | Description |
|------|-------------|
| `board_list_items` | List items on a board by type (sticky notes, shapes, etc.) |
| `context_explore` | Get a structural overview of the board (frames, docs, tables) |
| `context_get` | Extract text content from specific board items |
| `diagram_get_dsl` | Get DSL format for entity-relationship diagrams |
| `diagram_create` | Create diagrams on a board from DSL |
| `table_create` | Create a new table on a board |
| `table_list_rows` | List rows from an existing table |
| `table_sync_rows` | Sync/update rows in a table |
| `doc_get` | Read a document from the board |
| `doc_update` | Update an existing document |
| `doc_create` | Create a new document on the board |
| `image_get_url` | Get the URL of an image on the board |
| `image_get_data` | Get the raw image data |

You can now go back to Claude Code and the Miro MCP will be connected.

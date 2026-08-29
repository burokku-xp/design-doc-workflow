# GitHub MCP + gh CLI Fallback

Shared by `design-to-pr`, `design-to-issues`, and `impl-from-design`.

For full workflow map with other skills/MCP: [workflow-integrations.md](workflow-integrations.md).

## Strategy

1. Call `GetDynamicTools` with pattern `github` to check GitHub MCP availability
2. If available → `CallDynamicTool` with **explicit arguments**
3. If unavailable → fall back to `gh` CLI

User may have GitHub MCP installed in Cursor Settings directly (not only via plugin `mcp.json`). Always discover tools at runtime.

## GitHub MCP setup

Plugin template: `mcp.json` at plugin root. User copies to `.cursor/mcp.json` and sets `GITHUB_PAT` in Plugins → Configure.

Hosted server: `https://api.githubcopilot.com/mcp/`

Alternative (local): Docker `ghcr.io/github/github-mcp-server` with `GITHUB_PERSONAL_ACCESS_TOKEN`.

**Do not use** deprecated npm `@modelcontextprotocol/server-github`.

## MCP: create pull request

Always pass all required arguments explicitly (known Cursor issue with missing args):

```json
{
  "owner": "<github-owner>",
  "repo": "<repo-name>",
  "title": "設計: <feature title> (<feature-id>)",
  "head": "design/<feature-id>",
  "base": "main",
  "body": "<PR body from template>"
}
```

Tool name: `create_pull_request` (verify exact name via `GetDynamicTools`).

Use `CallDynamicTool`:
- namespace: from discovery (e.g. `github`)
- toolName: `create_pull_request`
- arguments: `{ owner, repo, title, head, base, body }`

## MCP: comment on PR / issue

Use GitHub MCP comment tools if available, else:

```bash
gh pr comment <number> --body "..."
gh issue comment <number> --body "..."
```

## MCP: create issue

Pass owner, repo, title, body, and labels explicitly. Verify tool schema via `GetDynamicTools`.

## gh CLI fallback

### Create PR

```bash
gh pr create \
  --base main \
  --head "design/<feature-id>" \
  --title "設計: <title> (<feature-id>)" \
  --body-file /tmp/pr-body.md \
  --label design
```

### Create issue

```bash
gh issue create \
  --title "[Epic] <title> (<feature-id>)" \
  --body-file /tmp/issue-body.md \
  --label "epic,design-approved"
```

### Comment on issue

```bash
gh issue comment <number> --body "<message>"
```

## Resolve owner/repo

From git remote:

```bash
git remote get-url origin
# github.com:owner/repo.git → owner, repo
```

Or ask user if ambiguous.

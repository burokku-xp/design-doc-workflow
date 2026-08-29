# Playwright MCP Integration

Shared by `e2e-from-design`. User may install via Cursor Settings → MCP (`npx @playwright/mcp@latest`).

## Discovery

1. `GetDynamicTools` with pattern `playwright`
2. Inspect tool schemas before calling

Namespace may appear as `playwright` or similar depending on MCP config name.

## Typical tools (Playwright MCP)

| Tool | Use for |
|------|---------|
| `browser_navigate` | Open app URL (local dev server) |
| `browser_snapshot` | Accessibility tree + element refs |
| `browser_click` | Click by ref from snapshot |
| `browser_type` | Fill inputs |
| `browser_fill_form` | Multiple fields at once |
| `browser_take_screenshot` | Visual check (optional) |

Exact names vary by version — always verify via `GetDynamicTools`.

## Debug workflow (e2e-from-design)

```
1. Ensure dev server running (e.g. localhost:3000)
2. browser_navigate → base URL + route from screens.md
3. browser_snapshot → find refs for labels/buttons
4. browser_type / browser_click → replay tests.md scenario
5. Verify expected state from snapshot
6. Encode working flow into tests/e2e/TST-xxx.spec.ts
7. Run npx playwright test for repeatable CI run
```

## MCP vs CLI

| Mode | When |
|------|------|
| **Playwright MCP** | Interactive debug, exploring UI, fixing flaky selectors |
| **`npx playwright test`** | CI, PR checks, final verification |

Cloud Agent: prefer CLI headless; MCP when headed browser available.

## With cursor-subscriptions

After pushing test changes:

```
subscribe_github_ci(branch) → wait for Playwright job in GitHub Actions
```

On failure: read CI logs, fix spec, push again.

## With design docs

- Read scenario from `tests.md` (TST-ID)
- Read selectors hints from `screens.md` (labels, button names)
- Do **not** edit `docs/design/` from Playwright sessions

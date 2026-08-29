---
name: e2e-from-design
description: Generates and runs Playwright tests from docs/design/ tests.md. Creates E2E and component tests with TST-ID and CMP-ID naming. Uses Playwright MCP for local debug. Use when writing frontend tests, Playwright, E2E tests, or テストを作って from design.
---

# E2E from Design

Generates **Playwright tests** from `tests.md` in design docs. Frontend tests use Playwright exclusively (no Vitest/RTL). Part of **design-doc-workflow** plugin.

## Prerequisites

- Implementation exists (or UI stubbed for component tests)
- `tests.md` defines TST-IDs with scenarios
- `screens.md`, `components.md`, `flows.md` for E2E/component details
- Playwright MCP configured (Cursor Settings or plugin `mcp.json`) or local Playwright installed

See [../_shared/playwright-mcp.md](../_shared/playwright-mcp.md) and [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

## Workflow

```
Task Progress:
- [ ] Step 1: Read tests.md traceability and scenarios
- [ ] Step 2: Scaffold Playwright if missing (templates/playwright/)
- [ ] Step 3: Write E2E specs (tests/e2e/TST-xxx.spec.ts)
- [ ] Step 4: Write component specs (tests/components/CMP-xxx.spec.ts)
- [ ] Step 5: Run tests (Playwright MCP or npx playwright test)
- [ ] Step 6: Report results; comment on Issue if failures
```

### Step 1: Read tests.md

Extract for each TST-ID:
- Target (E2E flow vs component)
- Scenario steps and expected results
- Related REQ, SCR, CMP, API

### Step 2: Scaffold

If user project lacks Playwright config, copy from plugin `templates/playwright/`:

- `playwright.config.ts`
- `tests/e2e/_template.spec.ts`
- `tests/components/_template.spec.ts`
- Add scripts to `package.json`: `test:e2e`, `test:ct`

### Step 3: E2E specs

Path: `tests/e2e/TST-<FEATURE>-<NNN>.spec.ts`

Derive from `screens.md` + `flows.md`:
- Navigation per SCR routes
- User actions from screen cards
- Assertions from state tables and acceptance criteria

Test title must include TST-ID: `test('TST-AUTH-001: login success', ...)`

### Step 4: Component specs

Path: `tests/components/CMP-<FEATURE>-<NNN>.spec.ts`

Use `@playwright/experimental-ct-react` when project supports it.

Derive from `components.md`:
- Render component in isolation
- Props / events per design tables
- Validation and error display per `screens.md` states

### Step 5: Run tests

**Local CLI:**
```bash
npx playwright test
npx playwright test tests/e2e/TST-AUTH-001.spec.ts
```

**Playwright MCP (debug):**

1. `GetDynamicTools` pattern `playwright` → discover tools
2. Start dev server if needed
3. `browser_navigate` → `browser_snapshot` → interact by ref
4. Translate working flow into spec file

Details: [../_shared/playwright-mcp.md](../_shared/playwright-mcp.md)

**After push:** `subscribe_github_ci` to wait for Playwright CI job (subscribe skill).

### Step 6: Report

- Pass: note in PR or Issue which TST-IDs are covered
- Fail: comment on Sub-Issue with failure summary — **do not edit design docs**
- CI: ensure GitHub Actions runs `npx playwright test` on PR

## Test mapping rules

| tests.md type | Output |
|---------------|--------|
| E2E / 画面フロー | `tests/e2e/TST-xxx.spec.ts` |
| UI / コンポーネント | `tests/components/CMP-xxx.spec.ts` |
| Backend (Service/Controller) | JUnit — use `impl-from-design`, not this skill |

## Rules

- Every TST-ID in scope gets at least one automated test
- Test names include TST-ID or CMP-ID
- Do not modify `docs/design/`
- Do not use Vitest or React Testing Library for frontend

## Additional resources

- Templates: [reference.md](reference.md)
- Plugin templates: `templates/playwright/`

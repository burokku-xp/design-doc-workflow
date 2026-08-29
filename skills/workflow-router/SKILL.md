---
name: workflow-router
description: Detects user workflow state (design, handoff, implement, test) from git branch, docs/design/manifest.yaml, and repo changes. Suggests the appropriate design-doc-workflow skill when the user is not already using it. Use at conversation start, when the user asks what to do next, 次何する, 続き, or when design/implementation/testing context is detected without the matching skill.
---

# Workflow Router

Proactively checks **where the user is in the pipeline** and suggests the right skill if they are not already on it.

Part of **design-doc-workflow** plugin. See [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

## When to run

- User asks: 次何する, 続き, 何から始める, workflow, 状態
- User talks about 設計書 / 実装 / テスト but does not invoke a matching skill
- Start of task in a repo that has `docs/design/`
- After completing a phase (e.g. "設計書書いた") — suggest next skill

**Do not** suggest if:
- User already invoked the correct skill this turn
- User explicitly chose a different path
- Same suggestion was declined in this conversation

## Quick detect

Run state script (locate script before running):

```bash
# 1) Repo root (plugin cloned or copied into project)
SCRIPT="skills/workflow-router/scripts/detect-state.sh"

# 2) Plugin install path (Cursor Plugins)
if [[ ! -f "$SCRIPT" ]]; then
  SCRIPT=$(find "${HOME}/.cursor" -path '*/skills/workflow-router/scripts/detect-state.sh' 2>/dev/null | head -1)
fi

bash "$SCRIPT" .
```

Or manually check:

| Signal | Source |
|--------|--------|
| Branch `design/*` | git |
| Branch `feat/*` | git |
| `docs/design/*/manifest.yaml` | status, features |
| Uncommitted `docs/design/` | design in progress |
| Uncommitted `src/`, `backend/` | implementation in progress |
| Open PR (design vs feat) | GitHub MCP or `gh pr list` |
| Open Issues with REQ-ID | GitHub MCP or `gh issue list` |
| `tests/e2e/*.spec.ts` vs `tests.md` | test gap |

## Phase → Skill map

| Phase | Signals | Suggest skill | Example prompt |
|-------|---------|---------------|----------------|
| **0. No design** | No `docs/design/` | `design-doc` | `design-doc スキルで <feature> の設計書を作って` |
| **1. Designing** | draft manifest, `design/*` branch, editing docs | `design-doc` | 設計書の続き / 更新 |
| **1b. Design review** | draft complete, user approved | `design-to-pr` | `design-to-pr スキルで <feature> の設計PRを作って` |
| **2. Handoff** | design merged, status approved, no issues | `design-to-issues` | `design-to-issues スキルで Issue を作って` |
| **3. Implementing** | Sub-Issue, `feat/*` branch, code changes | `impl-from-design` | `impl-from-design スキルで Issue #N を実装して` |
| **3b. Minor adjust** | User asks wording/threshold change | `impl-from-design` + same feat PR | 設計も合わせて（軽微調整） |
| **4. Review** | feat PR open | `impl-review` + **subscribe** | `impl-review スキルで PR #N をレビューして` |
| **5. Testing** | impl done, no/minimal Playwright specs | `e2e-from-design` | `e2e-from-design スキルで Playwright テストを作って` |

## Suggestion format

Keep it **one short block** at the end of the response (unless user only asked for status):

```markdown
---
**ワークフロー提案**（推定: 設計フェーズ / feature: user-auth）
いま `design-doc` Skill が適しています。設計PRまで進めるなら:
→ `design-to-pr スキルで user-auth の設計PRを作って`
```

## MCP-enhanced detection (optional)

If GitHub MCP available:
- List open PRs → distinguish `design/*` vs `feat/*`
- List issues labeled `implementation` / `epic`

If Playwright MCP available and phase is test:
- Suggest interactive debug before writing specs

Use **subscribe** after suggesting impl-review or post-push: wait for CI/review.

## Integrated skills reminder

| Need | Also mention |
|------|--------------|
| Library API during impl | context7-mcp |
| Wait for CI/review | subscribe skill |
| Notion instead of GitHub | spec-to-implementation / tasks-build |

## Rules

- Suggest, do not force — user can ignore
- One primary skill per suggestion
- Match user's language (Japanese OK in prompts)

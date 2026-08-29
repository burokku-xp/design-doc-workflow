---
name: impl-review
description: Reviews implementation PRs for design alignment and code readability. Accepts minor design doc updates in the same feat PR when documented in 仕様調整 section. Use when reviewing implementation PRs, コードレビュー, or after impl-from-design completes.
---

# Implementation Review

Reviews **implementation PRs** for design alignment and readable code. Part of **design-doc-workflow** plugin.

## When to use

- After `impl-from-design` opens a PR
- User asks: PRをレビューして, コードレビュー, impl-review

## Workflow

```
Task Progress:
- [ ] Step 1: Load PR diff and linked Sub-Issue
- [ ] Step 2: Verify design doc paths and REQ-ID coverage
- [ ] Step 3: Check design doc changes (minor adjustments OK if documented)
- [ ] Step 4: Review code quality (clean-code rule)
- [ ] Step 5: Check layer boundaries and test coverage prep
- [ ] Step 6: Post review summary (comment only — no auto-merge)
```

### Step 1: Context

- PR title, body, `Closes #` issue
- Sub-Issue REQ-ID and design doc links
- Changed files list

### Step 2: Design alignment

| Check | Pass criteria |
|-------|---------------|
| REQ coverage | All REQ-IDs in issue are addressed |
| API | Endpoints match `api.md` (method, path, errors) |
| Screens | Routes and states match `screens.md` |
| Components | Split matches `components.md` |
| Layers | Controller/Service/Repository match `layers.md` |

### Step 3: Design doc changes

**No `docs/design/` changes** — pass (default).

**If PR includes `docs/design/` changes:**

- [ ] PR has **仕様調整（軽微）** section explaining what changed
- [ ] Change is minor: wording, thresholds, labels, state clarifications
- [ ] REQ-ID unchanged; no new API paths/methods or screen flow changes
- [ ] Code and design updates are consistent

**Fail** if:
- Design changed without user request or PR explanation
- Major spec change bundled in feat PR (should be separate design PR)

### Step 4: Code readability (clean-code)

- [ ] Names express intent
- [ ] Functions reasonably short; no deep nesting
- [ ] No magic numbers
- [ ] No unnecessary abstractions
- [ ] Design IDs referenced in tests or comments where helpful

### Step 5: Layer boundaries

**Java:**
- [ ] No business logic in Controller
- [ ] Service owns transactions and rules
- [ ] Repository is data access only

**React:**
- [ ] Components match design units
- [ ] Loading/error states per `screens.md`

### Step 6: Test readiness

- [ ] Backend JUnit tests for in-scope TST-IDs (or noted as follow-up)
- [ ] Playwright spec placeholders or follow-up issue for `e2e-from-design`

### Review output format

Post as PR comment (or summary to user):

```markdown
## レビュー結果

### 設計整合性
- [ ] REQ/API/SCR 対応

### コード品質
- [ ] 読みやすさ
- [ ] 層責務

### 設計書
- [ ] 変更なし、または 仕様調整（軽微）が PR に明記され REQ/API/フロー不変

### 指摘
- 🔴 Critical: ...
- 🟡 Suggestion: ...
- 🟢 Nice to have: ...

### 次ステップ
- [ ] 修正後再レビュー
- [ ] e2e-from-design で Playwright テスト
```

## Rules

- **Never auto-merge** — human approval required
- AI review is advisory; post suggestions only
- Optional: use `cursor-subscriptions` `subscribe_github_pr` to wait for human review replies

## Integrated skills

| Skill / MCP | Use |
|-------------|-----|
| **subscribe** | After PR opened — wait for CI/review without polling |
| **context7-mcp** | Not in review — but verify library usage matches design |
| **GitHub MCP** | Read PR comments via MCP if available |

See [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

## Related Skills

- **e2e-from-design** — after review passes, generate Playwright tests

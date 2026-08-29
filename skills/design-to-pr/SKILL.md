---
name: design-to-pr
description: Creates a design pull request from docs/design/ after human review. Creates branch design/<feature-id>, commits design documents, and opens a GitHub PR with label design. Use when the user approves a design draft and asks to create a design PR, 設計PR, or submit design for review.
---

# Design to PR

Opens a **design PR** for human review. Design docs must already exist under `docs/design/`.

Part of the **design-doc-workflow** Cursor Plugin. PR body template: `templates/github/design.md`.

## Prerequisites

- Design docs written (via `design-doc` skill or manually)
- User explicitly approves creating the PR
- `manifest.yaml` has `status: draft` (will stay draft until merged)

## Workflow

```
Task Progress:
- [ ] Step 1: Validate design docs exist
- [ ] Step 2: Create branch design/<feature-id>
- [ ] Step 3: Commit docs/design/ changes only
- [ ] Step 4: Push and open PR
- [ ] Step 5: Apply label and template
```

### Step 1: Validate

Confirm exists:
- `docs/design/<project>/manifest.yaml`
- `docs/design/<project>/features/<feature-id>/` (all chapters or user-approved subset)
- `docs/design/<project>/index.html`

If incomplete, stop and ask user to finish via `design-doc` skill.

If user's `.github/` templates are missing, copy from plugin `templates/github/`:

- `templates/github/design.md` → `.github/pull_request_template/design.md`
- `templates/github/implement-from-design.md` → `.github/ISSUE_TEMPLATE/implement-from-design.md`

### Step 2: Branch

```bash
git checkout -b design/<feature-id>
```

One feature per design PR. Multiple features → separate PRs unless user says otherwise.

### Step 3: Commit

Commit **only** `docs/design/` and `.github/` template changes. Message format:

```
docs(design): add <feature-id> detailed design

- Feature: <title>
- Status: draft
- Requirements: REQ-xxx, ...
```

### Step 4: Open PR

Title: `設計: <feature title> (<feature-id>)`

Body: use template from Step 4 section below.

**Create via GitHub MCP (preferred):**

1. `GetDynamicTools` — verify GitHub MCP available
2. Call `create_pull_request` with **explicit** arguments:

| Argument | Value |
|----------|-------|
| owner | from `git remote` |
| repo | from `git remote` |
| title | `設計: <title> (<feature-id>)` |
| head | `design/<feature-id>` |
| base | `main` (or default branch) |
| body | PR body from template |

See [../_shared/github-mcp.md](../_shared/github-mcp.md).

**Fallback (gh CLI):**

```bash
gh pr create --base main --head "design/<feature-id>" \
  --title "設計: <title> (<feature-id>)" \
  --body-file /tmp/design-pr-body.md --label design
```

Body template:

```markdown
## 設計書サマリ

| 項目 | 内容 |
|------|------|
| 機能ID | `<feature-id>` |
| ステータス | draft |
| 設計書 | `docs/design/<project>/features/<feature-id>/` |

## レビュー観点

- [ ] 機能要件・受け入れ条件は明確か
- [ ] API・画面・DBの対応は整合しているか
- [ ] 表・図で全体像が把握できるか
- [ ] 他機能との依存関係は正しいか

### 画面設計

- [ ] 全ユースケースに画面が対応しているか
- [ ] 各画面にカード（目的・レイアウト・状態）があるか
- [ ] 画面遷移図に抜け・行き止まりがないか
- [ ] 対応マトリクスで REQ / API / CMP が紐づいているか
- [ ] components.md は screens.md の後に書かれているか

## 設計書プレビュー

ローカル: `docs/design/<project>/index.html` をブラウザで開く

## 承認後の次ステップ

マージ後、`design-to-issues` スキルで実装Issueを作成する。

---

**注意**: このPRは設計書のみ。実装コードは含めない。
```

### Step 5: Labels

Add label: `design`

If label missing, note in PR body.

### Step 6: Wait for review (optional)

After PR opened, use **subscribe** skill:
- `cursor-subscriptions-subscribe_github_pr` for this PR
- On wake: address review comments or remind user to merge

See [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

## Rules

- **Never** include implementation code in design PR
- **Never** change `status` to `approved` without explicit user/reviewer approval
- After merge, remind user to run `design-to-issues` for implementation handoff

## PR Review Flow

1. Human reviews tables and diagrams in PR diff
2. Request changes → update docs on same branch
3. Approve and merge → design becomes baseline on main
4. Implementation starts from issues, not by editing design during coding

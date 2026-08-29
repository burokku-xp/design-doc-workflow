---
name: design-to-issues
description: Creates GitHub implementation issues from an approved design in docs/design/. Generates an Epic issue and sub-issues per requirement (REQ-ID) with links to design docs, APIs, screens, and tests. Use when design PR is merged or approved and the user asks to create implementation issues, 実装Issue, or start development from design.
---

# Design to Issues

Converts approved design docs into **implementation issues** for seamless handoff to Cloud Agent or human developers.

Part of the **design-doc-workflow** Cursor Plugin. Issue templates: `templates/github/implement-from-design.md`.

## Prerequisites

- Design PR merged **or** user explicitly says design is approved
- `manifest.yaml` lists requirements with IDs
- Update `status: approved` in manifest only when user confirms approval

## Workflow

```
Task Progress:
- [ ] Step 1: Read manifest.yaml for feature
- [ ] Step 2: Create Epic issue
- [ ] Step 3: Create sub-issue per REQ-ID
- [ ] Step 4: Link issues and update manifest
- [ ] Step 5: Report issue URLs to user
```

### Step 1: Read manifest

From `docs/design/<project>/manifest.yaml`, extract:
- Feature id, title
- `requirements[]` with id, title, apis, screens, components, tests
- Doc paths
- Design PR number (if available)

### Step 2: Epic issue

**Create via GitHub MCP (preferred):** pass `owner`, `repo`, `title`, `body`, `labels` explicitly.

**Fallback (gh CLI):**

```bash
gh issue create --title "[Epic] <title> (<feature-id>)" \
  --body-file /tmp/epic-body.md --label "epic,design-approved"
```

See [../_shared/github-mcp.md](../_shared/github-mcp.md).

Title: `[Epic] <feature title> (<feature-id>)`

Body:

```markdown
## 概要
<feature summary from README.md>

## 設計書
- 設計PR: #<pr-number> (if merged)
- パス: `docs/design/<project>/features/<feature-id>/`
- プレビュー: `docs/design/<project>/index.html`

## 要件一覧
- [ ] #<sub-issue-1> REQ-xxx: ...
- [ ] #<sub-issue-2> REQ-yyy: ...

## 技術スタック
- Frontend: React + TypeScript
- Backend: Java Spring Boot (Controller / Service / Repository)

## 実装ルール
- 通常: `docs/design/` は**読み取り専用**
- 軽微な調整: 人間依頼時は同じ feat PR 内で設計書更新可
- 仕様と実装が食い違う場合はこのIssueにコメントで報告
- 大きな変更（REQ/API/フロー）は別 design PR

## 依存機能
<from manifest depends_on>
```

Labels: `epic`, `design-approved`

### Step 3: Sub-issue per REQ-ID

Title: `[<feature-id>] REQ-xxx: <requirement title>`

Body:

```markdown
## 要件
REQ-xxx: <title>

## 受け入れ条件
<from functional.md>

## 設計書参照（読み取り専用）
| 種別 | 参照 |
|------|------|
| 機能設計 | `docs/design/.../functional.md#req-xxx` |
| API | API-AUTH-001 → `.../api.md` |
| 層設計 | `.../layers.md` |
| 画面 | SCR-xxx → `.../screens.md` |
| コンポーネント | CMP-xxx → `.../components.md` |
| フロー | `.../flows.md` |
| テスト | TST-xxx → `.../tests.md` |

## 実装スコープ（目安）
- [ ] Backend: Controller / Service / Repository
- [ ] Frontend: 関連コンポーネント・画面
- [ ] テスト: TST-xxx

## Epic
Relates to #<epic-number>

## Cloud Agent 起動時
このIssueをコンテキストに「設計書を参照して実装して」と指示する。
```

Labels: `implementation`, `<feature-id>`

**Create via GitHub MCP or `gh issue create`** — same pattern as Epic. Link Epic in body after Epic number is known.

### Step 4: Update manifest

Add issue numbers to manifest (optional field):

```yaml
requirements:
  - id: REQ-AUTH-001
    issue: 123
```

Commit on a small chore branch or include in next PR — **do not** modify design content, only metadata.

### Step 5: Report

Tell user:
- Epic URL and sub-issue URLs
- Recommended: one Cloud Agent run per sub-issue
- Design docs remain read-only during implementation (minor adjustments: same feat PR per rules)

## Integrated skills

After creating issues via GitHub MCP, user may start implementation with `impl-from-design`.

Optional Notion track: `spec-to-implementation` + `tasks-build` instead — link `docs/design/` paths in Notion tasks. See [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

## Sizing Guide

| Size | Approach |
|------|----------|
| Small (1–2 REQ) | Epic + 1 sub-issue, or single issue with design PR link |
| Medium+ | Epic + one sub-issue per REQ-ID |
| Multi-layer | Note in sub-issue which layers to touch |

## Rules

- Issues link **to** design docs; do not copy full design into issue body
- Never auto-create issues without user request
- Sub-issues must reference traceability IDs for test coverage

## Additional Resources

Issue body field reference: [issue-templates.md](issue-templates.md)

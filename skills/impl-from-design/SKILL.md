---
name: impl-from-design
description: Implements features from approved design docs and GitHub issues. Reads docs/design/ by default; minor spec adjustments may update design docs in the same feat PR when the user explicitly requests. Use when implementing from a Sub-Issue, 実装して, or when the user asks to implement from design for React and Java Spring Boot.
---

# Implement from Design

Implements code from **approved design docs** and a GitHub Sub-Issue. Part of **design-doc-workflow** plugin.

## Prerequisites

- Design approved (`manifest.yaml` status `approved` or design PR merged)
- Sub-Issue with REQ-ID and design doc paths
- `rules/design-readonly.mdc` and `rules/clean-code.mdc` active

## Workflow

```
Task Progress:
- [ ] Step 1: Read Sub-Issue and design doc paths
- [ ] Step 2: Read relevant design chapters (read-only)
- [ ] Step 3: Implement backend then frontend (layer order)
- [ ] Step 4: Add backend JUnit tests for TST-IDs in scope
- [ ] Step 5: Commit and push feat branch
- [ ] Step 6: Open implementation PR (GitHub MCP or gh)
```

### Step 1: Read issue context

From Sub-Issue extract:
- REQ-ID, feature-id, project slug
- Linked API / SCR / CMP / TST IDs
- Acceptance criteria from `functional.md`

### Step 2: Read design

Default: read only. Edit `docs/design/` **only** when user explicitly requests a **minor adjustment** (same feat PR — see below).

| Chapter | Use for |
|---------|---------|
| functional.md | Business rules, REQ acceptance |
| api.md | Endpoints, inputs/outputs, errors |
| layers.md | Controller / Service / Repository responsibilities |
| db.md | Tables, columns |
| screens.md | Screen layout, states, transitions |
| components.md | Component split, tree |
| flows.md | Processing order |
| tests.md | TST-IDs to cover |

### Step 3: Implementation order

**Java backend:**
1. Entity + migration (if needed)
2. Repository
3. Service (business logic, `@Transactional`)
4. DTO
5. Controller

**React frontend:**
1. Feature components (`components.md`)
2. Screen / page (`screens.md`)
3. API client hooks
4. Route registration

Apply `rules/clean-code.mdc`: readable names, thin layers.

### Minor spec adjustment (same feat PR)

When user explicitly asks (e.g. 文言を変えて, 閾値を調整, 設計も合わせて):

1. Update only affected rows in relevant design files (`api.md`, `screens.md`, etc.)
2. Implement matching code change in same branch
3. Do **not** add/remove REQ-IDs or change API paths/methods
4. PR body must include **仕様調整** section (see Step 6)

If change affects REQ/API/screen flow → stop and propose separate design PR instead.

### Step 4: Backend tests

Add JUnit tests for TST-IDs in scope:
- Service: Mockito unit tests
- Controller: MockMvc integration tests
- Repository: `@DataJpaTest` when applicable

Frontend Playwright tests are **not** written here — use `e2e-from-design` skill after review.

### Step 5: Commit

Branch: `feat/<feature-id>` or `feat/<feature-id>-<req-id-lowercase>`

Message format:
```
feat(<feature-id>): implement REQ-xxx <title>

- REQ-xxx
- Layers: Controller, Service, Repository, ...
- Ref: docs/design/<project>/features/<feature-id>/
```

### Step 6: Open PR

Title: `[<feature-id>] REQ-xxx: <title>`

Body must include:
- `Closes #<sub-issue-number>`
- REQ-ID list
- Design doc paths
- Layers touched
- Note: Playwright tests follow in `e2e-from-design`

If minor spec adjustment was made, add:

```markdown
## 仕様調整（軽微）
- 変更内容: ...
- 更新した設計書: `docs/design/.../api.md` 等
- REQ-ID: 変更なし
```

**Create PR:** See [../_shared/github-mcp.md](../_shared/github-mcp.md)

Required MCP args: `owner`, `repo`, `title`, `head`, `base`, `body`

### Step 7: Wait for CI/review (optional)

After push, use **subscribe** skill + `cursor-subscriptions`:
- `subscribe_github_ci` for the branch
- `subscribe_github_pr` for the opened PR

On wake: run `impl-review` or fix CI failures. See [../_shared/workflow-integrations.md](../_shared/workflow-integrations.md).

### Library docs during implementation

When implementation needs framework API details, use **context7-mcp** skill:
- React, Spring Boot, Playwright docs
- Design docs define *what*; Context7 helps *how* for APIs

## When spec diverges

| Case | Action |
|------|--------|
| Minor tweak, user approved | Same feat PR: code + design tables |
| Unclear / user not asked | Comment on Issue; do not edit design or code spec |
| Major change (new REQ, API, flow) | Separate design PR; do not bundle in feat PR |

## Related Skills

- **impl-review** — after PR opened
- **e2e-from-design** — Playwright tests after merge or before final acceptance

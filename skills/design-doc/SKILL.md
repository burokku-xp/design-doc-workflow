---
name: design-doc
description: Creates human-readable detailed design documents (詳細設計書) using tables and diagrams, organized by feature. Outputs Markdown under docs/design/ with manifest.yaml and HTML index. Use when the user asks to create, draft, or update a design document, 設計書, spec, or feature design for React frontend and Java Spring Boot backend.
---

# Design Document Skill

Creates **human-first** design documents: tables and diagrams for overall understanding, **not** code-level specs.

## Plugin context

This skill ships as part of the **design-doc-workflow** Cursor Plugin.

| Plugin path | Purpose |
|-------------|---------|
| `templates/design/` | Blank scaffold copied into the user's `docs/design/<project>/` |
| `examples/my-app/` | Filled reference example (user-auth) |
| `templates/github/` | PR / Issue templates copied into user's `.github/` on first use |
| `rules/design-readonly.mdc` | Applied by plugin — design docs are read-only during implementation |

When scaffolding a new project, copy from `templates/design/` (not from `examples/`). Use `examples/my-app/` only as a quality reference.

## Core Principles

1. **Human comprehension first** — readers grasp the whole picture from tables, diagrams, and short prose.
2. **No code-level detail** — do not write class signatures, DTO definitions, or Props types. Use tables and natural language.
3. **Feature-unit organization** — one folder per feature under `docs/design/<project>/features/<feature-id>/`.
4. **Human-only edits** — only create or update design docs when the user explicitly requests. Never auto-update during implementation.
5. **AI reads, humans write** — design docs are the source of truth; implementation derives from them.

## Tech Stack Assumptions

| Layer | Stack |
|-------|-------|
| Frontend | React + TypeScript |
| Backend | Java Spring Boot, MVC (Controller / Service / Repository) |
| Docs format | Markdown source + `index.html` for human viewing |

## When to Use

- User says: 設計書を作って, 詳細設計, design doc, 機能設計, 仕様をまとめて
- Starting a new feature design from conversation
- User asks to add a feature section to existing design docs

## Workflow

```
Task Progress:
- [ ] Step 1: Confirm project name and feature-id
- [ ] Step 2: Scaffold docs/design/ if missing (from plugin templates/design/)
- [ ] Step 3: Gather requirements from conversation
- [ ] Step 4: Create or update manifest.yaml
- [ ] Step 5: Write feature docs (tables + Mermaid diagrams)
- [ ] Step 6: Screen design (see below) — before components.md
- [ ] Step 7: Regenerate index.html
- [ ] Step 8: Ask user to review before PR
```

### Scaffold (first time only)

If `docs/design/<project>/` does not exist in the user's workspace:

1. Copy `templates/design/00-project/` → `docs/design/<project>/00-project/`
2. Copy `templates/design/manifest.yaml` → `docs/design/<project>/manifest.yaml` (replace placeholders)
3. Copy `templates/design/features/_template/` → `docs/design/<project>/features/<feature-id>/`
4. Optionally copy `templates/github/*` → user's `.github/` if missing

### Confirm scope

## Screen Design Workflow

Write screens **before** `components.md`. Use the **screen card → transition diagram → traceability matrix** flow.

```
Screen Design Progress:
- [ ] 1. Derive screens from use cases (functional.md)
- [ ] 2. Write one screen card per SCR-ID (screens.md)
- [ ] 3. Draw screen transition diagram (screens.md)
- [ ] 4. Fill screen traceability matrix (screens.md)
- [ ] 5. Decompose into components (components.md) — only after screens are stable
```

### Step 1: Use cases → screens

From `functional.md` use cases, list required screens. Do not design components yet.

| UC-ID | 必要な画面 |
|-------|------------|
| UC-xxx | SCR-xxx |

### Step 2: Screen cards

One card per screen in `screens.md`. Each card includes:
- **目的** — why this screen exists (1–2 sentences)
- **レイアウト表** — area, element, behavior
- **ASCII wireframe** — optional, for quick visual grasp
- **状態表** — idle / loading / error / success
- **操作と結果** — user action → system response

No code, no Props types. Tables and short prose only.

### Step 3: Transition diagram

Mermaid `flowchart` showing all SCR-IDs and transitions. Check for dead ends and missing back navigation.

### Step 4: Traceability matrix

Single table linking screens to requirements, APIs, and components:

| SCR-ID | 画面 | 関連REQ | 呼ぶAPI | 主コンポーネント | 遷移先 |

### Step 5: Components (after screens)

Only after screen cards are reviewed, write `components.md` by decomposing each screen. Component tree must match screen cards.

### Screen design checklist (before PR)

- [ ] Every use case maps to at least one screen
- [ ] Every screen has a card (purpose, layout, states)
- [ ] Transition diagram has no gaps
- [ ] Traceability matrix links REQ / API / CMP
- [ ] `components.md` written after `screens.md`

For complex flows (wizards, approvals), add user-perspective sequences in `flows.md` **before** screen cards. See [reference.md](reference.md#screen-design).

### Confirm scope

Ask or infer:
- `project` slug (e.g. `my-app`)
- `feature-id` kebab-case (e.g. `user-auth`)
- `status`: always start as `draft` unless user says otherwise

### Step 2: Output location

```
docs/design/<project>/
├── manifest.yaml
├── index.html
├── 00-project/
│   ├── overview.md
│   ├── architecture.md
│   ├── feature-map.md
│   └── conventions.md
└── features/<feature-id>/
    ├── README.md
    ├── functional.md
    ├── api.md
    ├── layers.md
    ├── db.md
    ├── screens.md
    ├── components.md
    ├── flows.md
    └── tests.md
```

### Step 3: Write content rules

**DO write:**
- Summary tables (use cases, APIs, screens, components, tests)
- Mermaid diagrams (flowchart, sequenceDiagram, erDiagram)
- Traceability IDs: `REQ-`, `API-`, `SCR-`, `CMP-`, `TST-`, `UC-`, `BR-`
- One-line descriptions of responsibilities and I/O in natural language

**DO NOT write:**
- Java/TypeScript code blocks with signatures or types
- File path prescriptions beyond optional hints in component tables
- Implementation details that belong in code

### Step 4: manifest.yaml

Update `docs/design/<project>/manifest.yaml` with the feature entry, requirements, and cross-links. See [reference.md](reference.md#manifest-schema).

### Step 5: Regenerate index.html

Rebuild `docs/design/<project>/index.html` as a dashboard:
- Feature cards with status and links
- Embedded Mermaid for feature-map (from `00-project/feature-map.md`)
- Traceability table (REQ → API / Screen / Test)

Use the structure in [reference.md](reference.md#html-index).

### Step 6: Hand off

Tell the user:
- Design is `draft` until they approve
- Next step: run `design-to-pr` skill to open a design PR
- Do not proceed to implementation until design is approved

## Chapter Quick Reference

| File | Focus |
|------|-------|
| README.md | One-page feature summary |
| functional.md | Use cases + business rules tables |
| api.md | API list table + error table |
| layers.md | Controller / Service / Repository responsibility matrix |
| db.md | ER diagram + table definition tables |
| screens.md | Screen cards + transition diagram + traceability matrix |
| components.md | Component tree + list (write **after** screens.md) |
| flows.md | Sequence diagrams + state tables |
| tests.md | Traceability + Playwright E2E/CT scenarios + JUnit backend |

Full templates: [reference.md](reference.md)

## Example

See [examples.md](examples.md) for a minimal `user-auth` feature.

## Related Skills

- **design-to-pr** — after user approves draft, create design PR
- **design-to-issues** — after design PR is merged/approved, create implementation issues

## Additional Resources

- Templates and schemas: [reference.md](reference.md)
- Worked example: [examples.md](examples.md)

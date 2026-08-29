#!/usr/bin/env bash
# Detect design-doc-workflow state for skill routing.
# Usage: scripts/detect-state.sh [repo-root]
# Output: markdown summary (stdout)

set -euo pipefail
ROOT="${1:-.}"
cd "$ROOT"

phase="unknown"
branch=""
manifest=""
project=""
manifest_status=""
features_summary=""
open_prs=""
suggestions=""

branch=$(git branch --show-current 2>/dev/null || echo "")
if [[ -z "$branch" ]]; then
  branch="(no git branch)"
fi

# Manifest (user project: docs/design; plugin examples: examples/*/manifest.yaml)
manifest=$(find docs/design -name manifest.yaml 2>/dev/null | head -1 || true)
if [[ -z "$manifest" ]]; then
  manifest=$(find examples -maxdepth 2 -name manifest.yaml 2>/dev/null | head -1 || true)
fi
if [[ -n "$manifest" ]]; then
  project=$(grep -E '^project:' "$manifest" 2>/dev/null | head -1 | sed 's/project: *//' || echo "")
  manifest_status=$(grep -E '^status:' "$manifest" 2>/dev/null | head -1 | sed 's/status: *//' || echo "unknown")
  features_summary=$(grep -E '^\s+- id:' "$manifest" 2>/dev/null | sed 's/.*id: //' | tr '\n' ', ' | sed 's/, $//' || echo "")
fi

# Branch → likely phase
case "$branch" in
  design/*) phase="design" ;;
  feat/*)   phase="implement" ;;
  *)        phase="unknown" ;;
esac

# Uncommitted hints
design_dirty="no"
code_dirty="no"
if git rev-parse --git-dir >/dev/null 2>&1; then
  git diff --quiet -- docs/design 2>/dev/null || design_dirty="yes"
  git diff --quiet -- . ':(exclude)docs/design' 2>/dev/null || code_dirty="yes"
fi

# gh (optional)
if command -v gh >/dev/null 2>&1; then
  open_prs=$(gh pr list --state open --limit 5 --json number,title,headRefName 2>/dev/null | head -c 500 || echo "")
fi

# Playwright vs tests.md gap (rough)
playwright_specs=0
if [[ -d tests/e2e ]]; then
  playwright_specs=$(find tests/e2e -name '*.spec.ts' 2>/dev/null | wc -l | tr -d ' ')
fi

# Infer phase if branch unknown
if [[ "$phase" == "unknown" ]]; then
  if [[ "$design_dirty" == "yes" && -n "$manifest" ]]; then
    phase="design"
  elif [[ "$code_dirty" == "yes" ]]; then
    phase="implement"
  elif [[ -n "$manifest" && "$manifest_status" == "draft" ]]; then
    phase="design"
  elif [[ -n "$manifest" && "$manifest_status" == "approved" ]]; then
    phase="handoff_or_implement"
  fi
fi

# Recommend skill
recommended=""
case "$phase" in
  design)
    if [[ "$design_dirty" == "yes" ]]; then
      recommended="design-doc (更新中) → 完了後 design-to-pr"
    else
      recommended="design-doc または design-to-pr"
    fi
    ;;
  handoff_or_implement)
    recommended="design-to-issues（未作成なら）→ impl-from-design"
    ;;
  implement)
    if [[ "$playwright_specs" == "0" && -n "$manifest" ]]; then
      recommended="impl-from-design / impl-review → 完了後 e2e-from-design"
    else
      recommended="impl-from-design または impl-review"
    fi
    ;;
  *)
    if [[ -z "$manifest" ]]; then
      recommended="design-doc（設計書から開始）"
    else
      recommended="workflow-router で状態確認"
    fi
    ;;
esac

cat <<EOF
# Workflow State

| 項目 | 値 |
|------|-----|
| 推定フェーズ | $phase |
| ブランチ | $branch |
| 設計書 | ${manifest:-なし} |
| プロジェクト | ${project:-—} |
| manifest status | ${manifest_status:-—} |
| 機能 | ${features_summary:-—} |
| docs/design 未コミット | $design_dirty |
| コード未コミット | $code_dirty |
| Playwright E2E spec 数 | $playwright_specs |

## 推奨 Skill

**$recommended**

## Open PRs (gh)

${open_prs:-（gh 未使用または PR なし）}
EOF

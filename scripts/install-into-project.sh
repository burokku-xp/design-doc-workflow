#!/usr/bin/env bash
# Install design-doc-workflow into a project's .cursor/ for Cloud Agent + mobile support.
# Usage:
#   bash scripts/install-into-project.sh [project-dir]
#   curl -fsSL https://raw.githubusercontent.com/burokku-xp/design-doc-workflow/main/scripts/install-into-project.sh | bash
#   curl -fsSL ... | bash -s -- /path/to/project
set -euo pipefail

TARGET="$(cd "${1:-.}" && pwd)"
REPO="${DESIGN_DOC_WORKFLOW_REPO:-burokku-xp/design-doc-workflow}"
REF="${DESIGN_DOC_WORKFLOW_REF:-main}"

if [[ -f "$(dirname "$0")/bootstrap-project.sh" ]] && [[ -f "$(dirname "$0")/../.cursor-plugin/plugin.json" ]]; then
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
else
  TMP=$(mktemp -d)
  trap 'rm -rf "$TMP"' EXIT
  echo "Fetching design-doc-workflow@${REF} ..."
  git clone --depth 1 --branch "$REF" "https://github.com/${REPO}.git" "$TMP"
  ROOT="$TMP"
fi

bash "$ROOT/scripts/bootstrap-project.sh" "$TARGET"

echo ""
echo "Cloud Agent: commit .cursor/ and push. Secrets: cursor.com/dashboard → Cloud Agents → GITHUB_PAT"

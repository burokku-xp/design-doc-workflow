#!/usr/bin/env bash
# Copy plugin rules/skills/commands into a target project's .cursor/ (project-scoped fallback).
# Usage: bash scripts/bootstrap-project.sh /path/to/your-project
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:?Usage: bootstrap-project.sh /path/to/project}"

if [[ ! -d "$TARGET" ]]; then
  echo "ERROR: target directory not found: $TARGET" >&2
  exit 1
fi

CURSOR="$TARGET/.cursor"
mkdir -p "$CURSOR/rules" "$CURSOR/skills" "$CURSOR/commands"

# Rules
for f in "$ROOT/rules"/*.mdc; do
  cp "$f" "$CURSOR/rules/"
done

# Skills (skip _shared)
for d in "$ROOT/skills"/*/; do
  base=$(basename "$d")
  [[ "$base" == "_shared" ]] && continue
  rm -rf "$CURSOR/skills/$base"
  cp -R "$d" "$CURSOR/skills/$base"
done

# Commands
for f in "$ROOT/commands"/*.md; do
  cp "$f" "$CURSOR/commands/"
done

# Marker file
cat > "$CURSOR/design-doc-workflow.version" <<EOF
# Installed from design-doc-workflow plugin bootstrap
version=$(python3 -c "import json; print(json.load(open('$ROOT/.cursor-plugin/plugin.json'))['version'])")
source=$ROOT
EOF

echo "Bootstrapped .cursor/ in: $TARGET"
echo "  rules:    $(ls "$CURSOR/rules" | wc -l | tr -d ' ') files"
echo "  skills:   $(ls "$CURSOR/skills" | wc -l | tr -d ' ') dirs"
echo "  commands: $(ls "$CURSOR/commands" | wc -l | tr -d ' ') files"
echo ""
echo "Open this project in Cursor → Customize → scope: このプロジェクト名"

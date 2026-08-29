#!/usr/bin/env bash
# Copy plugin rules/skills/commands into a target project's .cursor/ (Cloud Agent + project scope).
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

# Skills (include _shared for cross-skill references)
for d in "$ROOT/skills"/*/; do
  base=$(basename "$d")
  rm -rf "$CURSOR/skills/$base"
  cp -R "$d" "$CURSOR/skills/$base"
done

# Commands (legacy; skills preferred in Cursor 2.4+)
for f in "$ROOT/commands"/*.md; do
  cp "$f" "$CURSOR/commands/"
done

VERSION=$(python3 -c "import json; print(json.load(open('$ROOT/.cursor-plugin/plugin.json'))['version'])")
REPO=$(python3 -c "import json; print(json.load(open('$ROOT/.cursor-plugin/plugin.json')).get('repository','https://github.com/burokku-xp/design-doc-workflow'))")

cat > "$CURSOR/design-doc-workflow.version" <<EOF
version=$VERSION
source=$REPO
installed_by=bootstrap-project.sh
EOF

cat > "$CURSOR/README.md" <<EOF
# design-doc-workflow (project-local)

Committed for **Cursor Cloud Agent**, mobile, and Web. PC Plugin install is optional.

- Skills: \`.cursor/skills/\` (7)
- Rules: \`.cursor/rules/\` (3)
- Docs: https://github.com/burokku-xp/design-doc-workflow/blob/main/docs/cloud-agent.md

Try: \`design-doc スキルで <feature> の設計書を作って\`
EOF

echo "Bootstrapped .cursor/ in: $TARGET"
echo "  rules:    $(find "$CURSOR/rules" -name '*.mdc' | wc -l | tr -d ' ') files"
echo "  skills:   $(find "$CURSOR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') dirs"
echo "  commands: $(find "$CURSOR/commands" -name '*.md' | wc -l | tr -d ' ') files"
echo ""
echo "Next: git add .cursor && git commit && git push  (required for Cloud Agent)"

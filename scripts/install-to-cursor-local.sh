#!/usr/bin/env bash
# Install design-doc-workflow to ~/.cursor/plugins/local/ (all projects).
# Usage: bash scripts/install-to-cursor-local.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME=$(python3 -c "import json; print(json.load(open('$ROOT/.cursor-plugin/plugin.json'))['name'])")
DEST="${HOME}/.cursor/plugins/local/${NAME}"

bash "$ROOT/scripts/validate-plugin.sh"

echo "Installing to: $DEST"
rm -rf "$DEST"
mkdir -p "$DEST"

rsync -a \
  --exclude '.git' \
  --exclude 'dist' \
  --exclude 'scripts' \
  "$ROOT/.cursor-plugin/" "$DEST/.cursor-plugin/" \
  "$ROOT/assets" "$ROOT/commands" "$ROOT/docs" "$ROOT/examples" \
  "$ROOT/mcp.json" "$ROOT/rules" "$ROOT/skills" "$ROOT/templates" \
  "$ROOT/LICENSE" "$ROOT/README.md" \
  "$DEST/"

# Local path install uses plugin.json only (marketplace.json not required)
rm -f "$DEST/.cursor-plugin/marketplace.json"

echo ""
echo "Installed. Next steps:"
echo "  1. Cursor → Developer: Reload Window"
echo "  2. Customize → scope: User → Skills / Rules に design-doc-workflow が表示されるか確認"
echo "  3. Plugins → Configure → GITHUB_PAT を設定"

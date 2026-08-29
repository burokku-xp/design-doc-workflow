#!/usr/bin/env bash
# Package design-doc-workflow as a distributable Cursor Plugin zip.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

bash scripts/validate-plugin.sh

name=$(python3 -c "import json; print(json.load(open('.cursor-plugin/plugin.json'))['name'])")
version=$(python3 -c "import json; print(json.load(open('.cursor-plugin/plugin.json')).get('version','0.0.0'))")
out_dir="$ROOT/dist"
artifact="$out_dir/${name}-${version}.zip"

mkdir -p "$out_dir"
rm -f "$artifact"

# Plugin root contents (Cursor loads .cursor-plugin/plugin.json at repo root)
zip -r "$artifact" \
  .cursor-plugin \
  assets \
  commands \
  docs \
  examples \
  mcp.json \
  rules \
  skills \
  templates \
  LICENSE \
  README.md \
  -x '*.git*' -x 'dist/*' -x 'scripts/*'

echo ""
echo "Packaged: $artifact"
echo "Install (all projects): bash scripts/install-to-cursor-local.sh"
echo "Install (one project):    bash scripts/bootstrap-project.sh /path/to/project"
echo "         Windows:           powershell -File scripts/install-to-cursor-local.ps1"

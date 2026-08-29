#!/usr/bin/env bash
# Validate design-doc-workflow Cursor Plugin structure.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
errors=0

fail() { echo "ERROR: $1" >&2; errors=$((errors + 1)); }
ok() { echo "OK: $1"; }

[[ -f .cursor-plugin/plugin.json ]] || fail "missing .cursor-plugin/plugin.json"
[[ -f .cursor-plugin/marketplace.json ]] || fail "missing .cursor-plugin/marketplace.json"
[[ -f mcp.json ]] || fail "missing mcp.json"
[[ -f assets/logo.svg ]] || fail "missing assets/logo.svg"
[[ -f README.md ]] || fail "missing README.md"

name=$(python3 -c "import json; print(json.load(open('.cursor-plugin/plugin.json'))['name'])")
version=$(python3 -c "import json; print(json.load(open('.cursor-plugin/plugin.json')).get('version',''))")
ok "manifest name=$name version=$version"
python3 - <<'PY' || fail "marketplace.json plugins[0].name must match plugin.json name"
import json
manifest = json.load(open(".cursor-plugin/plugin.json"))
market = json.load(open(".cursor-plugin/marketplace.json"))
plugins = market.get("plugins", [])
assert plugins, "marketplace.json plugins array is empty"
assert plugins[0].get("name") == manifest["name"], "marketplace plugin name mismatch"
assert plugins[0].get("source") == ".", "marketplace source must be '.' for root plugin"
PY
ok "marketplace.json validated"

for skill_dir in skills/*/; do
  base=$(basename "$skill_dir")
  [[ "$base" == "_shared" ]] && continue
  skill_file="$skill_dir/SKILL.md"
  if [[ ! -f "$skill_file" ]]; then
    fail "skill directory missing SKILL.md: $skill_dir"
    continue
  fi
  if ! head -1 "$skill_file" | grep -q '^---'; then
    fail "skill missing frontmatter: $skill_file"
  fi
done
ok "skills validated"

for rule in rules/*.mdc; do
  [[ -f "$rule" ]] || continue
  if ! head -1 "$rule" | grep -q '^---'; then
    fail "rule missing frontmatter: $rule"
  fi
done
ok "rules validated"

for cmd in commands/*.md; do
  [[ -f "$cmd" ]] || continue
  if ! head -1 "$cmd" | grep -q '^---'; then
    fail "command missing frontmatter: $cmd"
  fi
done
ok "commands validated"

if grep -q '\${GITHUB_PAT}' mcp.json; then
  python3 - <<'PY' || fail "GITHUB_PAT not declared in plugin.json variables"
import json
manifest = json.load(open(".cursor-plugin/plugin.json"))
props = manifest.get("variables", {}).get("properties", {})
assert "GITHUB_PAT" in props, "GITHUB_PAT missing from variables.properties"
PY
  ok "mcp.json GITHUB_PAT placeholder matches manifest variables"
fi

if [[ "$errors" -gt 0 ]]; then
  echo "Validation failed with $errors error(s)." >&2
  exit 1
fi

echo "Plugin validation passed."

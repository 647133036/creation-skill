#!/usr/bin/env bash
# Check superpowers: pure skills framework (markdown skills + JS harness), no build needed.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/superpowers"

if [ ! -d "$PKG" ]; then
  echo "[superpowers] FAIL: missing $PKG"
  exit 1
fi

# Verify skills directory is intact
SKILL_COUNT=$(find "$PKG/skills" -maxdepth 1 -mindepth 1 -type d | wc -l)
if [ "$SKILL_COUNT" -lt 1 ]; then
  echo "[superpowers] FAIL: skills/ directory empty or missing"
  exit 1
fi

# Verify package.json is valid JSON
if ! command -v node >/dev/null 2>&1; then
  echo "[superpowers] SKIP: node not found in PATH (cannot validate package.json)"
  exit 0
fi
if ! node -e "JSON.parse(require('fs').readFileSync('$PKG/package.json','utf8'))" 2>/dev/null; then
  echo "[superpowers] FAIL: package.json is not valid JSON"
  exit 1
fi

echo "[superpowers] PASS: $SKILL_COUNT skill dirs, package.json valid"

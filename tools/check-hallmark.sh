#!/usr/bin/env bash
# Check hallmark: pure skills framework (markdown skill + JS sloplint), no build needed.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/hallmark"

if [ ! -d "$PKG" ]; then
  echo "[hallmark] FAIL: missing $PKG"
  exit 1
fi

SKILL_DIR="$PKG/skills/hallmark"
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "[hallmark] FAIL: skills/hallmark/SKILL.md missing"
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[hallmark] SKIP: node not found in PATH (cannot validate package.json)"
  exit 0
fi
if ! node -e "JSON.parse(require('fs').readFileSync('$PKG/package.json','utf8'))" 2>/dev/null; then
  echo "[hallmark] FAIL: package.json is not valid JSON"
  exit 1
fi

GATES=$(find "$SKILL_DIR" -name "*.md" -type f | wc -l)
echo "[hallmark] PASS: skill entry + $GATES md docs, package.json valid"

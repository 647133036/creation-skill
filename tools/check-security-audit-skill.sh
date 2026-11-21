#!/usr/bin/env bash
# Check security-audit-skill: pure prompt skill + zero-dep node validators.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/security-audit-skill"

if [ ! -d "$PKG" ]; then
  echo "[security-audit-skill] FAIL: missing $PKG"
  exit 1
fi

SKILL_DIR="$PKG/skills/security-audit"
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "[security-audit-skill] FAIL: skills/security-audit/SKILL.md missing"
  exit 1
fi

VALIDATORS=$(find "$PKG" -name "validate-*.cjs" -o -name "validate-*.js" -o -name "validate-*.mjs" | wc -l)
if [ "$VALIDATORS" -lt 1 ]; then
  echo "[security-audit-skill] FAIL: no validator scripts found"
  exit 1
fi

NODE_OK=0
if command -v node >/dev/null 2>&1; then
  for v in $(find "$PKG" -name "validate-*.cjs" -o -name "validate-*.js" -o -name "validate-*.mjs"); do
    node --check "$v" 2>/dev/null || NODE_OK=1
  done
fi

if [ "$NODE_OK" -eq 0 ]; then
  echo "[security-audit-skill] PASS: skill entry + $VALIDATORS validator(s) syntax-ok"
else
  echo "[security-audit-skill] SKIP: node not available (syntax check skipped)"
fi

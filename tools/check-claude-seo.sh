#!/usr/bin/env bash
# Check claude-seo: Python SEO skill, pyproject manifest + pytest optional.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/claude-seo"

if [ ! -d "$PKG" ]; then
  echo "[claude-seo] FAIL: missing $PKG"
  exit 1
fi

if [ ! -f "$PKG/pyproject.toml" ]; then
  echo "[claude-seo] FAIL: pyproject.toml missing"
  exit 1
fi

SKILLS=$(find "$PKG/skills" -name "SKILL.md" 2>/dev/null | wc -l)
if [ "$SKILLS" -lt 1 ]; then
  echo "[claude-seo] FAIL: no SKILL.md under skills/"
  exit 1
fi

PYBIN="/opt/python3.15/bin/python3"
if [ ! -x "$PYBIN" ]; then
  PYBIN="$(command -v python3 || true)"
fi
if [ -z "$PYBIN" ]; then
  echo "[claude-seo] SKIP: python not available (manifest check only)"
  exit 0
fi

if ! "$PYBIN" -c "import tomllib,sys; tomllib.load(open('$PKG/pyproject.toml','rb'))" 2>/dev/null; then
  echo "[claude-seo] FAIL: pyproject.toml not valid TOML"
  exit 1
fi

echo "[claude-seo] PASS: pyproject valid, $SKILLS skill entries"

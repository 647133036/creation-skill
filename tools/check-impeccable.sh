#!/usr/bin/env bash
# Check impeccable: skill entry + Rust workspace manifest (cargo optional, no build).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/impeccable"

if [ ! -d "$PKG" ]; then
  echo "[impeccable] FAIL: missing $PKG"
  exit 1
fi

# Skill entry ships in per-harness skill dirs (.claude, .cursor, .codex, ...)
SKILL_OK=0
for h in .claude .cursor .codex .gemini .trae-cn .vibe .dsh; do
  if [ -f "$PKG/$h/skills/impeccable/SKILL.md" ]; then
    SKILL_OK=1
    break
  fi
done
if [ "$SKILL_OK" -eq 0 ]; then
  echo "[impeccable] FAIL: no skills/impeccable/SKILL.md in any harness dir"
  exit 1
fi

if ! grep -q "\[workspace\]" "$PKG/Cargo.toml" 2>/dev/null; then
  echo "[impeccable] FAIL: Cargo.toml workspace manifest missing"
  exit 1
fi

# Three states: SKIP when cargo is absent (manifest-only check), FAIL when
# cargo exists but the workspace metadata is invalid, PASS otherwise.
if ! command -v cargo >/dev/null 2>&1; then
  echo "[impeccable] SKIP: cargo not available (manifest check only)"
  exit 0
fi
if ! (cd "$PKG" && cargo metadata --no-deps --format-version 1 >/dev/null 2>&1); then
  echo "[impeccable] FAIL: cargo metadata invalid"
  exit 1
fi
echo "[impeccable] PASS: skill entry + Cargo workspace valid"

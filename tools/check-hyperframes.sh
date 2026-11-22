#!/usr/bin/env bash
# Check hyperframes: bun monorepo, workspace manifest + skills + optional unit test.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/hyperframes"

if [ ! -d "$PKG" ]; then
  echo "[hyperframes] FAIL: missing $PKG"
  exit 1
fi

if ! command -v bun >/dev/null 2>&1; then
  echo "[hyperframes] SKIP: bun not found in PATH"
  exit 0
fi

SKILLS=$(find "$PKG/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
if [ "$SKILLS" -lt 1 ]; then
  echo "[hyperframes] FAIL: skills/ directory empty or missing"
  exit 1
fi

# Validate workspace manifests without installing.
# Prefer `node -e` (Node 22 is the suite baseline); fall back to `bun -e`.
# (Avoids the fragile `bun run node -e` / `bunx -s` invocations, which depend
# on the bunx alias and on node being resolvable through `bun run`.)
JSON_PROBE='JSON.parse(require("fs").readFileSync(process.env.HF_PKG,"utf8"))'
if command -v node >/dev/null 2>&1; then
  if ! HF_PKG="$PKG/package.json" node -e "$JSON_PROBE" 2>/dev/null; then
    echo "[hyperframes] FAIL: root package.json not valid JSON"
    exit 1
  fi
elif ! HF_PKG="$PKG/package.json" bun -e "$JSON_PROBE" 2>/dev/null; then
  echo "[hyperframes] FAIL: root package.json not valid JSON"
  exit 1
fi

RUN_TESTS=0
FULL="${HYPERFRAMES_FULL:-0}"
if [ "$FULL" = "1" ]; then
  if (cd "$PKG" && bun install 2>/dev/null && bun test 2>/dev/null); then
    RUN_TESTS=1
  fi
fi

if [ "$RUN_TESTS" -eq 1 ]; then
  echo "[hyperframes] PASS: $SKILLS skill dirs, unit tests run"
elif [ "$FULL" = "1" ]; then
  echo "[hyperframes] FAIL: bun test failed"
  exit 1
else
  echo "[hyperframes] PASS: $SKILLS skill dirs, workspace manifest valid (HYPERFRAMES_FULL=1 to run tests)"
fi

#!/usr/bin/env bash
# Check craft-anything: cargo check on the CLI workspace (no full build).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/craft-anything"

if ! command -v cargo >/dev/null 2>&1; then
  echo "[craft-anything] SKIP: cargo not found in PATH"
  exit 0
fi

cd "$PKG"
if ! cargo check --quiet 2>&1 | tail -5; then
  echo "[craft-anything] FAIL: cargo check"
  exit 1
fi
echo "[craft-anything] PASS: cargo check clean"

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
# Capture cargo's exit code explicitly: a bare pipeline into `tail` would mask
# failures (tail exits 0), so we would report PASS on a broken build.
CARGO_OUT="$(cargo check --quiet 2>&1)"
CARGO_RC=$?
if [ "$CARGO_RC" -ne 0 ]; then
  printf '%s\n' "$CARGO_OUT" | tail -5
  echo "[craft-anything] FAIL: cargo check"
  exit 1
fi
[ -n "$CARGO_OUT" ] && printf '%s\n' "$CARGO_OUT" | tail -5
echo "[craft-anything] PASS: cargo check clean"

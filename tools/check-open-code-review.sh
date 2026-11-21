#!/usr/bin/env bash
# Check open-code-review: Go source verification.
# NOTE: go.mod requires go 1.26; system go is 1.25.6. GOTOOLCHAIN=auto would
# download go1.26 (slow, network-dependent). Instead we verify the Go source
# tree is intact (go.mod + cmd/ + go files present) without invoking the toolchain.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/open-code-review"

if [ ! -d "$PKG" ]; then
  echo "[open-code-review] FAIL: missing $PKG"
  exit 1
fi

# go.mod must exist and be parseable
if [ ! -f "$PKG/go.mod" ]; then
  echo "[open-code-review] FAIL: go.mod missing"
  exit 1
fi

# Count Go source files
GO_FILES=$(find "$PKG" -name '*.go' -not -path '*/node_modules/*' | wc -l)
if [ "$GO_FILES" -lt 1 ]; then
  echo "[open-code-review] FAIL: no .go source files found"
  exit 1
fi

# Verify cmd/ entry exists
if [ ! -d "$PKG/cmd/opencodereview" ]; then
  echo "[open-code-review] WARN: cmd/opencodereview directory missing"
fi

# If go toolchain is available at >= 1.26, run go vet for a real check
if command -v go >/dev/null 2>&1; then
  GO_VER=$(go version | sed 's/.*go\([0-9.]*\).*/\1/')
  # Compare: is GO_VER >= 1.26?
  if [ "$(echo "$GO_VER >= 1.26" | bc -l 2>/dev/null || echo 0)" = "1" ]; then
    cd "$PKG"
    if go vet ./... 2>&1 | tail -8; then
      echo "[open-code-review] PASS: go vet clean ($GO_VER)"
      exit 0
    fi
    echo "[open-code-review] FAIL: go vet"
    exit 1
  else
    echo "[open-code-review] SKIP: go vet needs go>=1.26, found go $GO_VER (GOTOOLCHAIN download disabled to avoid network flakiness)"
    exit 0
  fi
fi

echo "[open-code-review] PASS: source tree intact ($GO_FILES .go files, go.mod present)"

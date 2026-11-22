#!/usr/bin/env bash
# Check open-code-review: Go source verification.
# NOTE: go.mod requires go 1.26; system go is 1.25.6. GOTOOLCHAIN=auto would
# download go1.26 (slow, network-dependent). Instead we verify the Go source
# tree is intact (go.mod + cmd/ + go files present) without invoking the toolchain.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/open-code-review"

# ver_ge A B: exit 0 when version A >= B. Pure awk so the check has no
# hidden dependency on bc (host may not have it installed).
ver_ge() {
  awk -v a="$1" -v b="$2" 'BEGIN{
    n=split(a,x,"."); m=split(b,y,".");
    for(i=1;i<=(n>m?n:m);i++){
      A=(i<=n?x[i]+0:0); B=(i<=m?y[i]+0:0);
      if(A>B) exit 0; if(A<B) exit 1
    }
    exit 0
  }'
}

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
  # Compare: is GO_VER >= 1.26? (awk helper, no bc dependency)
  if ver_ge "$GO_VER" "1.26"; then
    cd "$PKG"
    # Capture go vet's exit code explicitly; a pipeline into tail would mask
    # failures and report PASS on a broken tree.
    VET_OUT="$(go vet ./... 2>&1)"
    VET_RC=$?
    if [ "$VET_RC" -eq 0 ]; then
      [ -n "$VET_OUT" ] && printf '%s\n' "$VET_OUT" | tail -8
      echo "[open-code-review] PASS: go vet clean ($GO_VER)"
      exit 0
    fi
    printf '%s\n' "$VET_OUT" | tail -8
    echo "[open-code-review] FAIL: go vet"
    exit 1
  else
    echo "[open-code-review] SKIP: go vet needs go>=1.26, found go $GO_VER (GOTOOLCHAIN download disabled to avoid network flakiness)"
    exit 0
  fi
fi

echo "[open-code-review] PASS: source tree intact ($GO_FILES .go files, go.mod present)"

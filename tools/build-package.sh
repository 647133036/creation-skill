#!/usr/bin/env bash
# Unified per-package build dispatcher (builds are no-ops for doc/script packages).
set -u
PKG="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

case "$PKG" in
  mygo-music)
    cd "$ROOT/packages/mygo-music" && go build ./... && echo "[mygo-music] build OK"
    ;;
  *)
    echo "[$PKG] build: no separate build step (script/doc package)"
    ;;
esac

#!/usr/bin/env bash
# Unified per-package build dispatcher (builds are no-ops for doc/script packages).
set -u
PKG="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

case "$PKG" in
  # No package in the monorepo has a dedicated build step today. When one is
  # added, wire its real build command here.
  *)
    echo "[$PKG] build: no separate build step (script/doc package)"
    ;;
esac

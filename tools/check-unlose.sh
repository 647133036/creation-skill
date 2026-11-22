#!/usr/bin/env bash
# Check unlose: source present, dotnet build/test on Windows only.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/unlose"

if [ ! -f "$PKG/src/Unlose.sln" ]; then
  echo "[unlose] FAIL: src/Unlose.sln not found"
  exit 1
fi

if ! command -v dotnet >/dev/null 2>&1; then
  echo "[unlose] SKIP: dotnet SDK not found (Windows-only build); source present"
  exit 0
fi

cd "$PKG/src"
# Capture dotnet's exit code explicitly; a pipeline into tail would mask failures.
BUILD_OUT="$(dotnet build Unlose.sln -c Release --nologo 2>&1)"
BUILD_RC=$?
if [ "$BUILD_RC" -ne 0 ]; then
  printf '%s\n' "$BUILD_OUT" | tail -5
  echo "[unlose] FAIL: dotnet build"
  exit 1
fi
printf '%s\n' "$BUILD_OUT" | tail -5
echo "[unlose] PASS: dotnet build clean"

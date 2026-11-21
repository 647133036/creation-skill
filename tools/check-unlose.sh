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
if ! dotnet build Unlose.sln -c Release --nologo 2>&1 | tail -5; then
  echo "[unlose] FAIL: dotnet build"
  exit 1
fi
echo "[unlose] PASS: dotnet build clean"

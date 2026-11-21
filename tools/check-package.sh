#!/usr/bin/env bash
# Unified per-package check dispatcher for the media-suite monorepo.
# Usage: bash tools/check-package.sh <package-name> <python315>
set -u
PKG="$1"
PY="${2:-/opt/python3.15/bin/python3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -x "$PY" ]; then
  echo "[$PKG] SKIP: Python 3.15 interpreter not found at $PY"
  exit 0
fi

case "$PKG" in
  ffmpeg-skill)            bash "$ROOT/tools/check-ffmpeg-skill.sh" "$PY" ;;
  gif-factory)             bash "$ROOT/tools/check-gif-factory.sh" "$PY" ;;
  cinecode)                bash "$ROOT/tools/check-cinecode.sh" "$PY" ;;
  claude-animated-shorts)  bash "$ROOT/tools/check-claude-animated-shorts.sh" "$PY" ;;
  cicada)                  bash "$ROOT/tools/check-cicada.sh" "$PY" ;;
  mygo-music)              bash "$ROOT/tools/check-mygo-music.sh" "$PY" ;;
  *) echo "[$PKG] FAIL: unknown package"; exit 1 ;;
esac

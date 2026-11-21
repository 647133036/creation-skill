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
  rea-video)               bash "$ROOT/tools/check-rea-video.sh" "$PY" ;;
  craft-anything)          bash "$ROOT/tools/check-craft-anything.sh" ;;
  unlose)                bash "$ROOT/tools/check-unlose.sh" ;;
  superpowers)           bash "$ROOT/tools/check-superpowers.sh" ;;
  open-code-review)      bash "$ROOT/tools/check-open-code-review.sh" ;;
  rea)                   bash "$ROOT/tools/check-rea.sh" ;;
  graphify)              bash "$ROOT/tools/check-graphify.sh" ;;
  *) echo "[$PKG] FAIL: unknown package"; exit 1 ;;
esac

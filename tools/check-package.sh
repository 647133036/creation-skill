#!/usr/bin/env bash
# Unified per-package check dispatcher for the media-suite monorepo.
# Usage: bash tools/check-package.sh <package-name> <python315>
set -u
PKG="$1"
PY="${2:-/opt/python3.15/bin/python3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -x "$PY" ]; then
  # Pure skill/prompt packages don't need Python; only Python-based ones do.
  case "$PKG" in
    ffmpeg-skill|gif-factory|cinecode|claude-animated-shorts|rea-video|graphify|claude-seo)
      echo "[$PKG] SKIP: Python 3.15 interpreter not found at $PY"
      exit 0
      ;;
  esac
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
  ai-website-cloner-template) bash "$ROOT/tools/check-ai-website-cloner-template.sh" ;;
  open-code-review)      bash "$ROOT/tools/check-open-code-review.sh" ;;
  rea)                   bash "$ROOT/tools/check-rea.sh" ;;
  graphify)              bash "$ROOT/tools/check-graphify.sh" ;;
  hallmark)              bash "$ROOT/tools/check-hallmark.sh" ;;
  impeccable)            bash "$ROOT/tools/check-impeccable.sh" ;;
  hyperframes)           bash "$ROOT/tools/check-hyperframes.sh" ;;
  security-audit-skill)  bash "$ROOT/tools/check-security-audit-skill.sh" ;;
  claude-seo)            bash "$ROOT/tools/check-claude-seo.sh" ;;
  *) echo "[$PKG] FAIL: unknown package"; exit 1 ;;
esac

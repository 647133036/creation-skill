#!/usr/bin/env bash
# claude-animated-shorts check: structure + Python helper compile + mjs syntax.
set -u
PY="$1"
P="$PWD/packages/claude-animated-shorts"

cd "$P" || exit 1
fail=0

for f in SKILL.md README.md LICENSE templates/bridge/story.ts templates/bridge/world.ts; do
  if [ ! -f "$f" ]; then
    echo "[claude-animated-shorts] FAIL: missing $f"
    fail=1
  fi
done

"$PY" -m compileall -q templates/audio templates/scripts || {
  echo "[claude-animated-shorts] FAIL: python compile under $("$PY" --version 2>&1)"
  fail=1
}

node --check templates/scripts/bridge-stills.mjs || fail=1

if [ "$fail" -eq 0 ]; then
  echo "[claude-animated-shorts] PASS: structure OK, python helpers compile under $("$PY" --version 2>&1), mjs syntax OK"
fi
exit "$fail"

#!/usr/bin/env bash
# ffmpeg-skill check: Python 3.15 compatibility smoke over every tool + contract self-check.
set -u
PY="$1"
P="$PWD/packages/ffmpeg-skill"
fail=0

cd "$P" || exit 1

# 1. Compile every Python file under the 3.15 interpreter.
if ! "$PY" -m compileall -q scripts mcp; then
  echo "[ffmpeg-skill] FAIL: compileall under $("$PY" --version 2>&1)"
  exit 1
fi

# 2. Every user-facing tool answers --help.
tools=0
for f in scripts/*.py; do
  base="$(basename "$f")"
  case "$base" in _*) continue ;; esac
  if ! "$PY" "$f" --help > /dev/null 2>&1; then
    echo "[ffmpeg-skill] FAIL: $base --help did not run under $("$PY" --version 2>&1)"
    fail=1
  fi
  tools=$((tools + 1))
done

# 3. Contract doctor: required capabilities on this machine.
"$PY" scripts/_contract.py doctor || {
  echo "[ffmpeg-skill] FAIL: contract doctor"
  exit 1
}

# 4. Runtime tool probe with the real ffmpeg (if present).
if command -v ffmpeg > /dev/null 2>&1; then
  ffmpeg -version | head -1
else
  echo "[ffmpeg-skill] SKIP: ffmpeg not on PATH"
fi

if [ "$fail" -eq 0 ]; then
  echo "[ffmpeg-skill] PASS: $tools tools ran --help under $("$PY" --version 2>&1)"
fi
exit "$fail"

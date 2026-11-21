#!/usr/bin/env bash
# gif-factory check: latest Pillow/NumPy/SciPy in a venv + script smoke.
set -u
PY="$1"
P="$PWD/packages/gif-factory"

cd "$P" || exit 1

if ! command -v ffmpeg > /dev/null 2>&1; then
  echo "[gif-factory] SKIP: ffmpeg not on PATH (needed for MP4 previews)"
fi

VENV="$P/.venv"
if [ ! -x "$VENV/bin/python" ]; then
  "$PY" -m venv "$VENV" || { echo "[gif-factory] FAIL: venv create"; exit 1; }
fi
# Latest stable pins, pre-release excluded.
"$VENV/bin/python" -m pip install --quiet --upgrade pip > /dev/null 2>&1
"$VENV/bin/python" -m pip install --quiet --upgrade "pillow" "numpy" "scipy" || {
  echo "[gif-factory] FAIL: pip install pillow numpy scipy"
  exit 1
}

echo "[gif-factory] deps: $("$VENV/bin/python" -c 'import PIL, numpy, scipy; print(f"Pillow {PIL.__version__}, NumPy {numpy.__version__}, SciPy {scipy.__version__}")')"

fail=0
for f in scripts/*.py; do
  if ! "$VENV/bin/python" "$f" --help > /dev/null 2>&1; then
    echo "[gif-factory] FAIL: $(basename "$f") --help"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "[gif-factory] PASS: all scripts ran --help under $("$VENV/bin/python" --version 2>&1) with latest deps"
fi
exit "$fail"

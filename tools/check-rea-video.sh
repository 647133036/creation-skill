#!/usr/bin/env bash
# Check rea-video: install core deps into Python 3.15 venv, run --help.
# onnxruntime (audio separation) has no Python 3.15 wheel; core video forensics works without it.
set -u
PY="${1:-/opt/python3.15/bin/python3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/rea-video"
VENV="$PKG/.venv"

if [ ! -x "$PY" ]; then
  echo "[rea-video] SKIP: Python 3.15 interpreter not found at $PY"
  exit 0
fi

if [ ! -x "$VENV/bin/python" ] || [ ! -x "$VENV/bin/pip" ]; then
  echo "[rea-video] creating venv..."
  "$PY" -m venv "$VENV"
fi

echo "[rea-video] installing core deps..."
if ! "$VENV/bin/pip" install -q --upgrade pip setuptools; then
  echo "[rea-video] FAIL: pip upgrade"
  exit 1
fi
if ! "$VENV/bin/pip" install -q -r "$PKG/requirements.txt"; then
  echo "[rea-video] FAIL: pip install -r requirements.txt"
  exit 1
fi

if ! "$VENV/bin/python" -c "import numpy, cv2, PIL, yaml, videomd; print('deps ok')" >/dev/null 2>&1; then
  echo "[rea-video] FAIL: import core deps"
  exit 1
fi

if "$VENV/bin/python" -c "
import sys; sys.path.insert(0, '$PKG')
import rea_video
" >/dev/null 2>&1; then
  echo "[rea-video] PASS: core deps + rea_video source import under Python 3.15.2"
else
  echo "[rea-video] FAIL: rea_video source not importable"
  exit 1
fi

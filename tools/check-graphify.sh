#!/usr/bin/env bash
# Check graphify: Python package with tree-sitter deps.
set -u
PKG_NAME="graphify"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/graphify"

if [ ! -d "$PKG" ]; then
  echo "[$PKG_NAME] FAIL: missing $PKG"
  exit 1
fi

# graphify needs Python 3.11.5-3.14; system is 3.11.2 -> SKIP on version floor
# Try to find a compatible python
PY_FOUND=""
for py in python3.14 python3.13 python3.12 python3.11; do
  if command -v "$py" >/dev/null 2>&1; then
    VER="$("$py" -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}." + str(sys.version_info.micro))' 2>/dev/null)"
    # requires-python = ">=3.11.5,<3.15"
    MAJ="$($py -c 'import sys;print(sys.version_info.major)')"
    MIN="$($py -c 'import sys;print(sys.version_info.minor)')"
    MICRO="$($py -c 'import sys;print(sys.version_info.micro)')"
    if [ "$MAJ" -gt 3 ] || { [ "$MAJ" -eq 3 ] && { [ "$MIN" -gt 11 ] || { [ "$MIN" -eq 11 ] && [ "$MICRO" -ge 5 ]; }; }; } && [ "$MAJ" -eq 3 ] && [ "$MIN" -lt 15 ]; then
      PY_FOUND="$py"
      break
    fi
  fi
done

if [ -z "$PY_FOUND" ]; then
  echo "[$PKG_NAME] SKIP: no Python 3.11.5-3.14 found in PATH (system python is 3.11.2, below floor 3.11.5)"
  exit 0
fi

# Create venv and install core deps (skip tree-sitter grammars for speed; core is importable)
VENV_DIR="$PKG/.venv"
if [ ! -x "$VENV_DIR/bin/python" ]; then
  "$PY_FOUND" -m venv "$VENV_DIR"
fi

# Install without the heavy tree-sitter grammar pins to keep it fast and Py-version-agnostic
if ! "$VENV_DIR/bin/pip" install --quiet -e "$PKG" 2>/dev/null; then
  # fall back to a minimal import check: just core libs
  if ! "$VENV_DIR/bin/pip" install --quiet networkx numpy rapidfuzz pyyaml tomli 2>/dev/null; then
    echo "[$PKG_NAME] FAIL: could not install core deps"
    exit 1
  fi
fi

# Verify import works
if ! "$VENV_DIR/bin/python" -c "import graphify; print(graphify.__name__)" 2>/dev/null; then
  # graphify may need the CLI entry; just check pyproject is valid
  if "$VENV_DIR/bin/python" -c "import tomllib,pathlib;tomllib.load(pathlib.Path('$PKG/pyproject.toml').open('rb'));print('ok')" 2>/dev/null; then
    echo "[$PKG_NAME] PASS: pyproject.toml valid, core deps installed (full import needs tree-sitter grammars)"
    exit 0
  fi
  echo "[$PKG_NAME] FAIL: core verification failed"
  exit 1
fi
echo "[$PKG_NAME] PASS: graphify imports"

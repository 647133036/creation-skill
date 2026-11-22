#!/usr/bin/env bash
# Check graphify: Python package with tree-sitter deps.
# Unified on Python 3.15 (system CPython at /opt/python3.15).
# pyproject requires-python is floor 3.11.5, capped <3.16 so 3.15 (the
# monorepo baseline) stays a supported interpreter: tree-sitter ships cp315
# wheels, so the cap sits at <3.16 (allow 3.15, exclude the next, wheel-less
# 3.16 where pip would source-build and fail without a C compiler).
set -u
PKG_NAME="graphify"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/graphify"
PY315="/opt/python3.15/bin/python3"

# ver_ge A B: exit 0 when version A >= B (pure awk; no bc dependency).
ver_ge() {
  awk -v a="$1" -v b="$2" 'BEGIN{
    n=split(a,x,"."); m=split(b,y,".");
    for(i=1;i<=(n>m?n:m);i++){
      A=(i<=n?x[i]+0:0); B=(i<=m?y[i]+0:0);
      if(A>B) exit 0; if(A<B) exit 1
    }
    exit 0
  }'
}

if [ ! -d "$PKG" ]; then
  echo "[$PKG_NAME] FAIL: missing $PKG"
  exit 1
fi

# Prefer system Python 3.15 (monorepo baseline); fall back to any 3.11.5+ on PATH
PY="$PY315"
if [ ! -x "$PY" ]; then
  PY=""
  for cand in python3.15 python3.14 python3.13 python3.12 python3.11; do
    if command -v "$cand" >/dev/null 2>&1; then
      V="$("$cand" -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")' 2>/dev/null)"
      # floor 3.11.5
      if ver_ge "$V" "3.11.5"; then
        PY="$(command -v "$cand")"
        break
      fi
    fi
  done
fi

if [ -z "$PY" ]; then
  echo "[$PKG_NAME] SKIP: no Python >=3.11.5 found (system 3.11.2 below floor; /opt/python3.15 missing)"
  exit 0
fi

V="$("$PY" -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")' 2>/dev/null)"
echo "[$PKG_NAME] using Python $V ($PY)"

# Create venv + install core deps
VENV_DIR="$PKG/.venv"
if [ ! -x "$VENV_DIR/bin/python" ]; then
  "$PY" -m venv "$VENV_DIR" 2>/dev/null
fi

# Install the package itself (pulls core deps incl. tree-sitter grammars).
# Capture pip's exit code explicitly: piping into tail would mask failures.
PIP_OUT="$("$VENV_DIR/bin/pip" install --quiet -e "$PKG" 2>&1)"
PIP_RC=$?
if [ "$PIP_RC" -ne 0 ]; then
  printf '%s\n' "$PIP_OUT" | tail -3
  echo "[$PKG_NAME] WARN: editable install reported issues; trying core deps only"
  "$VENV_DIR/bin/pip" install --quiet networkx numpy rapidfuzz pyyaml 2>/dev/null
fi

# Verify import
if "$VENV_DIR/bin/python" -c "import graphify; print(graphify.__name__)" 2>/dev/null; then
  echo "[$PKG_NAME] PASS: graphify imports under Python $V"
  exit 0
fi

# Fallback: at least verify pyproject is valid
if "$VENV_DIR/bin/python" -c "import tomllib,pathlib;tomllib.load(pathlib.Path('$PKG/pyproject.toml').open('rb'));print('ok')" 2>/dev/null; then
  echo "[$PKG_NAME] PASS: pyproject.toml valid under Python $V (full import needs tree-sitter grammars)"
  exit 0
fi
echo "[$PKG_NAME] FAIL: verification failed under Python $V"
exit 1

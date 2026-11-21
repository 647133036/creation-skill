#!/usr/bin/env bash
# Check claude-seo: Python 3.15 venv + requirements install + import smoke.
# Full pytest suite opt-in via CLAUDE_SEO_FULL=1.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/claude-seo"

if [ ! -d "$PKG" ]; then
  echo "[claude-seo] FAIL: missing $PKG"
  exit 1
fi

if [ ! -f "$PKG/pyproject.toml" ]; then
  echo "[claude-seo] FAIL: pyproject.toml missing"
  exit 1
fi

SKILLS=$(find "$PKG/skills" -name "SKILL.md" 2>/dev/null | wc -l)
if [ "$SKILLS" -lt 1 ]; then
  echo "[claude-seo] FAIL: no SKILL.md under skills/"
  exit 1
fi

PYBIN="/opt/python3.15/bin/python3"
if [ ! -x "$PYBIN" ]; then
  PYBIN="$(command -v python3 || true)"
fi
if [ -z "$PYBIN" ]; then
  echo "[claude-seo] SKIP: python not available (manifest check only)"
  exit 0
fi

if ! "$PYBIN" -c "import tomllib; tomllib.load(open('$PKG/pyproject.toml','rb'))" 2>/dev/null; then
  echo "[claude-seo] FAIL: pyproject.toml not valid TOML"
  exit 1
fi

VENV="$PKG/.venv"
if [ ! -x "$VENV/bin/python" ]; then
  "$PYBIN" -m venv "$VENV" || { echo "[claude-seo] FAIL: venv create"; exit 1; }
fi
"$VENV/bin/python" -m pip install --quiet --upgrade pip > /dev/null 2>&1

# google-ads (all releases <=35.1.0) declares Requires-Python <3.15, so it is
# not installable on the suite's 3.15 baseline. It only powers the optional
# seo-google keyword planner; core SEO stack installs without it.
REQS="$VENV/requirements-315.txt"
grep -v -E '^\s*google-ads' "$PKG/requirements.txt" > "$REQS"
GOOGLE_ADS_NOTE=" (google-ads not yet on 3.15; seo-google keyword planner optional)"

if ! "$VENV/bin/python" -m pip install --quiet -r "$REQS" 2>/tmp/claude-seo-pip.log; then
  echo "[claude-seo] FAIL: pip install core requirements (see /tmp/claude-seo-pip.log)"
  exit 1
fi

# Import smoke: core SEO stack. weasyprint needs system pango/cairo; treat
# its absence as a SKIP note rather than a failure of the Python baseline.
CORE_MODS="bs4 requests lxml lxml_html_clean trafilatura htmldate courlan numpy matplotlib openpyxl PIL urllib3 playwright googleapiclient googleapiclient.discovery"
fail=0
for m in $CORE_MODS; do
  if ! "$VENV/bin/python" -c "import $m" > /dev/null 2>&1; then
    echo "[claude-seo] FAIL: import $m"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  note="$GOOGLE_ADS_NOTE"
  if ! "$VENV/bin/python" -c "import weasyprint" > /dev/null 2>&1; then
    note="$note (weasyprint needs system pango; PDF report optional)"
  fi
  echo "[claude-seo] PASS: $SKILLS skills, deps + core imports OK under $("$VENV/bin/python" --version 2>&1)$note"
fi

if [ "${CLAUDE_SEO_FULL:-0}" = "1" ]; then
  if (cd "$PKG" && "$VENV/bin/python" -m pytest tests -x -q --timeout=600 2>/dev/null); then
    echo "[claude-seo] PASS: pytest suite under Python 3.15"
  else
    echo "[claude-seo] FAIL: pytest suite"
    exit 1
  fi
fi

exit "$fail"

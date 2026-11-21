#!/usr/bin/env bash
# cinecode check: Python 3.15 script smoke + Node capture.mjs syntax check.
set -u
PY="$1"
P="$PWD/packages/cinecode"

cd "$P/scripts" || exit 1

fail=0
py=0
for f in *.py; do
  if ! "$PY" "$f" --help > /dev/null 2>&1; then
    # Some helpers are import-only or expect args; compile them instead.
    if ! "$PY" -m py_compile "$f"; then
      echo "[cinecode] FAIL: $f"
      fail=1
      continue
    fi
  fi
  py=$((py + 1))
done

node --check capture.mjs || fail=1
node --check hook.cjs || fail=1

if [ "$fail" -eq 0 ]; then
  echo "[cinecode] PASS: $py python files OK under $("$PY" --version 2>&1); capture.mjs/hook.cjs syntax OK on node $(node --version)"
fi
exit "$fail"

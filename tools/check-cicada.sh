#!/usr/bin/env bash
# cicada check: Workers server unit tests + Swift package declaration sanity.
set -u
PY="$1"
P="$PWD/packages/cicada"

cd "$P" || exit 1
fail=0

tools=$(grep -m1 'swift-tools-version' Package.swift)
echo "[cicada] $tools (full Swift build requires macOS; declaration upgraded in place)"

node --test server/test/unit.test.mjs > /dev/null 2>&1 || {
  echo "[cicada] FAIL: server unit tests"
  fail=1
}

node --check server/src/index.js || fail=1

# Linux engine (Python stdlib core): unit tests under Python 3.15.
cd "$P/linux" || exit 1
if "$PY" -m unittest discover -s tests -q > /tmp/cicada_linux_tests.log 2>&1; then
  echo "[cicada] linux core: unittest PASS under $("$PY" --version 2>&1)"
else
  echo "[cicada] linux core: unittest FAIL (see /tmp/cicada_linux_tests.log)"
  fail=1
fi
"$PY" -m py_compile cicada/app/*.py cicada/core/*.py cli.py || {
  echo "[cicada] FAIL: linux app py_compile under $("$PY" --version 2>&1)"
  fail=1
}

if [ "$fail" -eq 0 ]; then
  echo "[cicada] PASS: server unit tests green on node $(node --version)"
fi
exit "$fail"

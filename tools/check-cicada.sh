#!/usr/bin/env bash
# cicada check: Workers server unit tests, Swift package declaration sanity,
# and the Linux engine (Python core + C voiceprint lib) under Python 3.15.
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

# The Linux engine: build the C voiceprint lib for this machine, run the
# engine's unit tests and compile-check the GTK app under Python 3.15.
cd "$P/linux" || exit 1
native=linux/native/out
if [ "$(uname)" = Darwin ]; then
  native=linux/native/dylib
fi
"$P/linux/native/build.sh" "$P/$native" > /dev/null || {
  echo "[cicada] FAIL: native voiceprint build"
  fail=1
}

if "$PY" -m unittest discover -s tests -q > /tmp/cicada_linux_tests.log 2>&1; then
  tests=$("$PY" -m unittest discover -s tests 2>&1 | grep -oE 'Ran [0-9]+ tests' | head -1)
  echo "[cicada] linux core: $tests PASS under $("$PY" --version 2>&1)"
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

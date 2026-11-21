#!/usr/bin/env bash
# mygo-music check: go vet + build + internal tests, and the website build,
# both on upgraded dependencies.
set -u
P="$PWD/packages/mygo-music"

cd "$P" || exit 1
fail=0

go vet ./... || fail=1
go build ./... || fail=1
go test ./internal/... || fail=1

# The website builds with vite, which asks the GitHub API for the latest
# release and the published plugins while it builds. GH_TOKEN or
# GITHUB_TOKEN, if set, is sent with the request, for the API's rate limit.
cd "$P/website" || exit 1
bun install || fail=1
bun run build || fail=1

if [ "$fail" -eq 0 ]; then
  echo "[mygo-music] PASS: vet + build + tests + website on $(go version | awk '{print $3, $4}')"
fi
exit "$fail"

#!/usr/bin/env bash
# Check ai-website-cloner-template: agent skill + Next.js 16 scaffold, no build needed.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/packages/ai-website-cloner-template"

if [ ! -d "$PKG" ]; then
  echo "[ai-website-cloner-template] FAIL: missing $PKG"
  exit 1
fi

SKILL_DIR="$PKG/.agents/skills/clone-website"
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "[ai-website-cloner-template] FAIL: .agents/skills/clone-website/SKILL.md missing"
  exit 1
fi
REFS=$(find "$SKILL_DIR/references" -name "*.md" -type f | wc -l)
if [ "$REFS" -lt 2 ]; then
  echo "[ai-website-cloner-template] FAIL: inspection-guide/framer-and-motion references missing"
  exit 1
fi

for doc in AGENTS.md CLAUDE.md; do
  if [ ! -f "$PKG/$doc" ]; then
    echo "[ai-website-cloner-template] FAIL: $doc missing"
    exit 1
  fi
done

for f in next.config.ts tsconfig.json src/app/layout.tsx src/app/page.tsx src/components/ui; do
  if [ ! -e "$PKG/$f" ]; then
    echo "[ai-website-cloner-template] FAIL: Next.js scaffold incomplete ($f missing)"
    exit 1
  fi
done

if ! command -v node >/dev/null 2>&1; then
  echo "[ai-website-cloner-template] SKIP: node not found in PATH (cannot validate package.json)"
  exit 0
fi
if ! node -e "JSON.parse(require('fs').readFileSync('$PKG/package.json','utf8'))" 2>/dev/null; then
  echo "[ai-website-cloner-template] FAIL: package.json is not valid JSON"
  exit 1
fi

echo "[ai-website-cloner-template] PASS: clone-website skill + $REFS references, agent docs, Next.js scaffold, package.json valid"

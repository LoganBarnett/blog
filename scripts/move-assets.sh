#!/usr/bin/env bash
# Move root-level deployable assets (images, PDFs, image maps) to static/.
# Hugo serves static/ contents at the site root, so existing org references
# like [[file:foo.png]] keep working without path edits.
#
# Files are moved with `git mv` when tracked, plain `mv` otherwise.
# Skipped: TeX sources, JS samples (already moved to org/), markdown sources.

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p static

shopt -s nullglob 2>/dev/null || setopt null_glob

count=0
for f in *.png *.jpeg *.jpg *.svg *.pdf *.map; do
  [[ -f "$f" ]] || continue
  if git ls-files --error-unmatch -- "$f" >/dev/null 2>&1; then
    git mv "$f" "static/$f"
  else
    mv "$f" "static/$f"
  fi
  count=$((count + 1))
done

echo "moved $count asset files into static/"

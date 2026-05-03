#!/usr/bin/env bash
# Clean a Jekyll-era org file and emit the ox-hugo-ready version under org/.
#
# - Strips Jekyll frontmatter block (#+BEGIN_EXPORT html ... #+END_EXPORT)
# - Strips :PROPERTIES: ... :END: property drawers (we no longer persist
#   CUSTOM_IDs; org-auto-id-mode handles anchors at export time)
# - Strips #+auto_id: keyword
# - Extracts categories: from old Jekyll block when present
# - Adds ox-hugo directives + alias for the legacy /<slug>.html URL
# - Output: org/<slug>.org  (date prefix stripped from _posts filenames)
#
# Skip list: README and unfinished drafts the user wants left alone.

set -euo pipefail

cd "$(dirname "$0")/.."

SKIP=(
  "README.org"
  "second-principles.org"
  "time-budgeting.org"
  "vim-to-emacs.org"
  "llm-2026.org"
  "sonify-health.org"
)

skip_p() {
  local f="$1"
  for s in "${SKIP[@]}"; do
    [[ "$f" == "$s" ]] && return 0
  done
  return 1
}

clean_one() {
  local src="$1"
  local slug

  if [[ "$src" =~ ^_posts/[0-9]{4}-[0-9]{2}-[0-9]{2}-(.+)\.org$ ]]; then
    slug="${BASH_REMATCH[1]}"
  else
    slug="$(basename "$src" .org)"
  fi

  local dest="org/${slug}.org"

  local category
  category=$(awk '
    /^#\+BEGIN_EXPORT html/,/^#\+END_EXPORT/ {
      if (tolower($0) ~ /^categories:/) {
        sub(/^[Cc]ategories:[[:space:]]*/, "")
        print
        exit
      }
    }
  ' "$src" | tr -d ' \r')

  # Cleaning passes:
  #   - drop Jekyll #+BEGIN_EXPORT html block
  #   - drop :PROPERTIES: drawers
  #   - drop #+auto_id: keyword
  #   - rewrite #+include: "../../path  ->  "../../../path  to compensate for
  #     the extra directory level introduced by moving files into org/
  awk '
    BEGIN { in_export = 0; in_props = 0 }
    /^#\+BEGIN_EXPORT html$/ { in_export = 1; next }
    /^#\+END_EXPORT$/ && in_export { in_export = 0; next }
    in_export { next }
    /^[[:space:]]*:PROPERTIES:[[:space:]]*$/ { in_props = 1; next }
    /^[[:space:]]*:END:[[:space:]]*$/ && in_props { in_props = 0; next }
    in_props { next }
    tolower($0) ~ /^#\+auto_id:/ { next }
    /^#\+include:[[:space:]]*"\.\.\// {
      sub(/"\.\.\//, "\"../../")
      print
      next
    }
    { print }
  ' "$src" > "$dest"

  local hugo_block="#+hugo_base_dir: ..
#+hugo_section: posts
#+hugo_aliases: /${slug}.html"
  if [[ -n "$category" ]]; then
    hugo_block="${hugo_block}
#+hugo_categories: ${category}"
  fi

  local header_end
  header_end=$(awk '
    BEGIN { last_kw = 0; printed = 0 }
    /^#\+[A-Za-z_]+:/ { last_kw = NR; next }
    /^[[:space:]]*$/ { next }
    { print last_kw; printed = 1; exit }
    END { if (!printed) print last_kw }
  ' "$dest")

  local tmp="${dest}.tmp"
  if [[ -n "$header_end" && "$header_end" -gt 0 ]]; then
    head -n "$header_end" "$dest" > "$tmp"
    printf '%s\n' "$hugo_block" >> "$tmp"
    tail -n +"$((header_end + 1))" "$dest" >> "$tmp"
  else
    printf '%s\n\n' "$hugo_block" > "$tmp"
    cat "$dest" >> "$tmp"
  fi
  mv "$tmp" "$dest"
}

mkdir -p org

count=0
for f in *.org _posts/*.org; do
  [[ -f "$f" ]] || continue
  if skip_p "$(basename "$f")"; then
    echo "skip $f"
    continue
  fi
  clean_one "$f"
  count=$((count + 1))
done

echo "cleaned $count files into org/"

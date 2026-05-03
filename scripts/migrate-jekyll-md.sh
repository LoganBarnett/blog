#!/usr/bin/env bash
# Convert Jekyll-era _posts/*.{md,markdown} into content/posts/<slug>.md.
#
# Jekyll posts have YAML front matter like:
#   ---
#   layout: post
#   title:  "Markdown flavored shoes"
#   date:   2015-08-13 19:01:00
#   categories: markdown
#   ---
#
# We translate to TOML, drop layout/published, add a Hugo alias for the
# legacy /<slug>.html URL, and strip the YYYY-MM-DD- prefix from the
# filename (the existing permalink rule already drops dates).

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p content/posts

migrate_one() {
  local src="$1"
  local fname slug
  fname=$(basename "$src")
  slug="${fname#????-??-??-}"
  slug="${slug%.md}"
  slug="${slug%.markdown}"

  local dest="content/posts/${slug}.md"

  awk -v slug="$slug" '
    BEGIN { in_fm = 0; fm_done = 0; title=""; date=""; cats="" }
    /^---[[:space:]]*$/ {
      if (!in_fm && !fm_done) { in_fm = 1; next }
      if (in_fm)              { in_fm = 0; fm_done = 1
        printf "+++\n"
        if (title != "") printf "title = %s\n", title
        if (date != "")  printf "date = \"%s\"\n", date
        if (cats != "")  printf "categories = [\"%s\"]\n", cats
        printf "aliases = [\"/%s.html\"]\n", slug
        printf "+++\n"
        next
      }
    }
    in_fm {
      if ($1 == "title:") {
        sub(/^title:[[:space:]]*/, "")
        # If quoted, keep the quotes for TOML; otherwise wrap.
        if ($0 ~ /^".*"$/) title = $0
        else { gsub(/"/, "\\\""); title = "\"" $0 "\"" }
        next
      }
      if ($1 == "date:")       { sub(/^date:[[:space:]]*/, "");       date = $0; next }
      if ($1 == "categories:") { sub(/^categories:[[:space:]]*/, ""); cats = $0; next }
      next  # skip layout, published, anything else
    }
    { print }
  ' "$src" > "$dest"
}

count=0
for f in _posts/*.md _posts/*.markdown; do
  [[ -f "$f" ]] || continue
  migrate_one "$f"
  count=$((count + 1))
done

echo "migrated $count jekyll markdown posts into content/posts/"

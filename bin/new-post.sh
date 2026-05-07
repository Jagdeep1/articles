#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bin/new-post.sh --title "My Post Title"      # create empty stub via `hugo new`
#   bin/new-post.sh path/to/raw.md               # convert raw markdown into a Hugo post

usage() {
  cat >&2 <<EOF
Usage:
  $0 --title "My Post Title"
  $0 path/to/raw.md
EOF
  exit 1
}

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-z0-9' '-' \
    | sed 's/^-//; s/-$//'
}

# cd to repo root (script lives in bin/)
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

[ $# -ge 1 ] || usage

if [ "$1" = "--title" ]; then
  shift
  [ $# -ge 1 ] || usage
  TITLE="$1"
  SLUG="$(slugify "$TITLE")"
  [ -n "$SLUG" ] || { echo "error: empty slug from title" >&2; exit 1; }
  TARGET="content/en/posts/${SLUG}.md"
  [ ! -e "$TARGET" ] || { echo "error: $TARGET already exists" >&2; exit 1; }
  hugo new content "en/posts/${SLUG}.md" >/dev/null
  # rewrite the auto-titled stub with the user-supplied title
  TMP="$(mktemp)"
  awk -v t="$TITLE" '
    NR==1 && /^---$/ { print; in_fm=1; next }
    in_fm && /^title:/ { print "title: \"" t "\""; next }
    in_fm && /^---$/ { print; in_fm=0; next }
    { print }
  ' "$TARGET" > "$TMP" && mv "$TMP" "$TARGET"
  echo "$TARGET"
  exit 0
fi

# Convert mode
SRC="$1"
[ -f "$SRC" ] || { echo "error: $SRC not found" >&2; exit 1; }

BASE="$(basename "$SRC" .md)"
SLUG="$(slugify "$BASE")"
[ -n "$SLUG" ] || { echo "error: empty slug from filename" >&2; exit 1; }
TARGET="content/en/posts/${SLUG}.md"
[ ! -e "$TARGET" ] || { echo "error: $TARGET already exists" >&2; exit 1; }

mkdir -p content/posts

FIRST_LINE="$(head -n1 "$SRC")"
if [ "$FIRST_LINE" = "---" ]; then
  # Already has frontmatter — just move into place
  mv "$SRC" "$TARGET"
else
  TITLE="$(printf '%s' "$BASE" | sed 's/[-_]/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
  DATE="$(date +%Y-%m-%dT%H:%M:%S%z)"
  {
    echo "---"
    echo "title: \"$TITLE\""
    echo "date: $DATE"
    echo "draft: false"
    echo "tags: []"
    echo "---"
    echo
    cat "$SRC"
  } > "$TARGET"
  rm "$SRC"
fi

echo "$TARGET"

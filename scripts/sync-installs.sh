#!/usr/bin/env bash
# Sync adversarial-multi-model-review skill files to Cursor and/or Claude install locations.
#
# Usage:
#   ./scripts/sync-installs.sh                    # user-level Cursor (default)
#   ./scripts/sync-installs.sh <cursor-dest> ...  # user Cursor + project Cursor dest(s)
#   ./scripts/sync-installs.sh --claude           # user-level Claude
#   ./scripts/sync-installs.sh --claude <dest> ...# user Claude + project Claude dest(s)
#   ./scripts/sync-installs.sh --all              # user-level Cursor + Claude
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_SRC="${SRC}"
CLAUDE_SRC="${SRC}/claude"
USER_CURSOR_DEST="${HOME}/.cursor/skills/adversarial-multi-model-review"
USER_CLAUDE_DEST="${HOME}/.claude/skills/adversarial-multi-model-review"

sync_cursor() {
  local dest="$1"
  mkdir -p "$dest"
  rsync -av --delete \
    --exclude '.DS_Store' \
    "${CURSOR_SRC}/SKILL.md" \
    "${CURSOR_SRC}/assets/" \
    "${CURSOR_SRC}/references/" \
    "${dest}/"
  echo "Synced Cursor skill -> ${dest}"
}

sync_claude() {
  local dest="$1"
  mkdir -p "$dest"
  rsync -av --delete \
    --exclude '.DS_Store' \
    "${CLAUDE_SRC}/" \
    "${dest}/"
  echo "Synced Claude skill -> ${dest}"
}

MODE="cursor"
DESTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude) MODE="claude" ;;
    --all) MODE="all" ;;
    --cursor) MODE="cursor" ;;
    *) DESTS+=("$1") ;;
  esac
  shift
done

case "$MODE" in
  cursor)
    sync_cursor "${USER_CURSOR_DEST}"
    for dest in "${DESTS[@]}"; do sync_cursor "$dest"; done
    ;;
  claude)
    sync_claude "${USER_CLAUDE_DEST}"
    for dest in "${DESTS[@]}"; do sync_claude "$dest"; done
    ;;
  all)
    sync_cursor "${USER_CURSOR_DEST}"
    sync_claude "${USER_CLAUDE_DEST}"
    for dest in "${DESTS[@]}"; do
      if [[ "$dest" == *"/.claude/"* ]]; then
        sync_claude "$dest"
      else
        sync_cursor "$dest"
      fi
    done
    ;;
esac

echo "Done."

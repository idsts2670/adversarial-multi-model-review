#!/usr/bin/env bash
# Sync adversarial-multi-model-review skill files to Cursor install locations.
# Usage:
#   ./scripts/sync-installs.sh                    # user-level only
#   ./scripts/sync-installs.sh <project-dest> ... # user-level + project dest(s)
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
USER_DEST="${HOME}/.cursor/skills/adversarial-multi-model-review"

RSYNC_EXCLUDES=(
  --exclude 'README.md'
  --exclude 'scripts/'
  --exclude '.DS_Store'
  --exclude '.git/'
  --exclude 'LICENSE'
  --exclude '.gitignore'
)

sync_one() {
  local dest="$1"
  mkdir -p "$dest"
  rsync -av "${RSYNC_EXCLUDES[@]}" --delete "${SRC}/" "${dest}/"
  echo "Synced -> ${dest}"
}

sync_one "${USER_DEST}"

if [[ $# -gt 0 ]]; then
  for dest in "$@"; do
    sync_one "${dest}"
  done
fi

echo "Done."

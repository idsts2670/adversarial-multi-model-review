# adversarial-multi-model-review

Multi-model adversarial mutual review for **Cursor** and **Claude Code** — facilitator + panelists, rounds 0–3, synthesis. English only.

## Install — Cursor

Copy or rsync **only** `SKILL.md`, `assets/`, and `references/` from the repo root — not `README.md`, `claude/`, `scripts/`, or `examples/`.

| Location | Path pattern | Scope |
|---|---|---|
| User-level | `~/.cursor/skills/adversarial-multi-model-review/` | All Cursor projects |
| Project-level | `<repo>/.cursor/skills/adversarial-multi-model-review/` | One repository |

```bash
PKG_ROOT="$(pwd)"
SKILL_FILES="SKILL.md assets references"

mkdir -p "${HOME}/.cursor/skills/adversarial-multi-model-review"
rsync -av --delete ${SKILL_FILES} "${HOME}/.cursor/skills/adversarial-multi-model-review/"
```

Or use the helper script:

```bash
./scripts/sync-installs.sh
./scripts/sync-installs.sh /path/to/repo/.cursor/skills/adversarial-multi-model-review
```

## Install — Claude Code

Copy the **`claude/`** subtree to a Claude skills directory:

| Location | Path pattern | Scope |
|---|---|---|
| User-level | `~/.claude/skills/adversarial-multi-model-review/` | All Claude projects |
| Project-level | `<repo>/.claude/skills/adversarial-multi-model-review/` | One repository |

```bash
PKG_ROOT="$(pwd)"

mkdir -p "${HOME}/.claude/skills/adversarial-multi-model-review"
rsync -av --delete "${PKG_ROOT}/claude/" "${HOME}/.claude/skills/adversarial-multi-model-review/"
```

Or:

```bash
./scripts/sync-installs.sh --claude
./scripts/sync-installs.sh --claude /path/to/repo/.claude/skills/adversarial-multi-model-review
./scripts/sync-installs.sh --all   # user-level Cursor + Claude
```

### Claude project permissions

Merge into the target repo's **project-level** `.claude/settings.json` (see `examples/claude-settings.fragment.json`):

```json
"permissions": {
  "allow": [
    "Agent",
    "Bash(codex *)"
  ]
}
```

The Claude `SKILL.md` also declares `allowed-tools: Agent Bash(codex *)` (active when the skill runs, after workspace trust). Restart Claude Code after editing settings.

## Usage

- "Run adversarial-multi-model-review on this design"
- "Red-team this architecture decision"
- "Are you sure? Run a panel on this"

**Claude Code:** `/adversarial-multi-model-review`

## Panelist tiers

**Cursor**

1. **Tier 1** — Different model family via `Task`, or optional **Codex CLI**
2. **Tier 2** — Different Cursor models on `Task`
3. **Tier 3** — Same model, forced methodological divergence

**Claude Code**

1. **Tier 1** — **Codex CLI** (cross-vendor)
2. **Tier 2** — Different Claude models on **Agent**
3. **Tier 3** — Same model, forced methodological divergence

Default: **2 panelists × 3 rounds**.

## Codex CLI (optional)

Requires install + auth (`codex login` or `CODEX_API_KEY`). Separate from the Codex Claude plugin.

```bash
codex --version 2>/dev/null || echo "codex not available"

OUT="/tmp/adversarial-multi-model-review-$(uuidgen | tr '[:upper:]' '[:lower:]').md"
codex exec --ephemeral -s read-only -m "${CODEX_MODEL:-}" \
  "your panelist prompt here" \
  -o "$OUT" </dev/null
```

- **`</dev/null` is mandatory** in non-TTY agent shells — without it, Codex waits on stdin and hangs.
- **Read `$OUT`** for the validation gate; do not treat stderr progress as the answer.

Codex is optional. Fall back to Tier 2/3 if unavailable.

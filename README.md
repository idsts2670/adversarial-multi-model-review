# adversarial-multi-model-review

Multi-model adversarial mutual review for **Cursor** and **Claude Code**: facilitator plus panelists, rounds 0 through 3, then synthesis.

![Architecture](assets/architecture.png)

The facilitator (main session) distributes a self-contained brief. Panelists cross-critique each other and return answers and critiques. The facilitator synthesizes the result.

## Install

This package ships two skill layouts:

| Host | Source | User-level path |
|---|---|---|
| **Cursor** | repo root (`SKILL.md`, `assets/`, `references/`) | `~/.cursor/skills/adversarial-multi-model-review/` |
| **Claude Code** | `claude/` | `~/.claude/skills/adversarial-multi-model-review/` |

Copy or rsync the skill files for your host. Do not copy `README.md` or `scripts/`.

```bash
# From this package root:
SKILL_FILES="SKILL.md assets references"

# Cursor (user-level)
mkdir -p "${HOME}/.cursor/skills/adversarial-multi-model-review"
rsync -av --delete ${SKILL_FILES} "${HOME}/.cursor/skills/adversarial-multi-model-review/"

# Claude Code (user-level)
mkdir -p "${HOME}/.claude/skills/adversarial-multi-model-review"
rsync -av --delete claude/ "${HOME}/.claude/skills/adversarial-multi-model-review/"
```

Or use the helper script:

```bash
./scripts/sync-installs.sh              # Cursor user-level
./scripts/sync-installs.sh --claude     # Claude Code user-level
./scripts/sync-installs.sh --all        # both
```

## Usage

In Cursor or Claude Code:

- "Run adversarial-multi-model-review on this design"
- "Red-team this architecture decision"
- "Are you sure? Run a panel on this"

Or reference the `adversarial-multi-model-review` skill directly.

## Panelist tiers

1. **Tier 1 (Cursor default):** `gemini-3.1-pro` + `gpt-5.6-sol-high` via Task — **required `model` slugs**; optional **Codex CLI** as GPT fallback; (Claude Code) optional **Antigravity CLI** (`agy -p`)
2. **Tier 2:** Different models on the host when user overrides defaults
3. **Tier 3:** Same model, forced methodological divergence

**Cursor:** required slugs in `references/cursor-dispatch.md`. Do not substitute Opus for the GPT panelist. Do not use `agy` in Cursor.

**Claude Code:** optional Antigravity (`agy -p`) or Codex. See `references/claude-code-dispatch.md` (Cursor copy) or `claude/references/claude-dispatch.md`.

Default: **2 panelists × 3 rounds**.

## Codex CLI (optional)

```bash
codex --version
codex login          # once, in a real terminal
codex exec "prompt" </dev/null
```

Codex is optional. Fall back to Tier 2/3 if unavailable.

## Antigravity CLI (Claude Code, optional)

For Claude Code hosts without Cursor Task. Not recommended in Cursor; use Task with `gemini-*` instead.

One-time auth in a **human terminal** (never from an agent shell), then `agy --mode plan -p "prompt"`. See `references/claude-code-dispatch.md`.

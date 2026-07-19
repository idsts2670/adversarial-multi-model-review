---
name: adversarial-multi-model-review
description: >-
  Run a multi-model adversarial mutual review: 2+ panelists independently answer,
  cross-critique across rounds, and the main session synthesizes agreements,
  live disagreements, and calibrated confidence. Use when the user asks to debate
  or adversarially review a claim, hypothesis, design, or decision; says "red-team
  this", "second opinion", "are you sure?", "adversarial review", or wants
  high-stakes answers with explicit uncertainty instead of a single-pass response.
  Also use proactively when the user challenges your confidence on something
  consequential.
allowed-tools: Agent Bash(codex *)
---

# Adversarial Multi-Model Review

Multi-model adversarial mutual review for Claude Code. Several models answer independently, attack each other's answers, revise under critique, and the facilitator (main session) synthesizes the result. English only.

## When to use

- Architecture decisions, root-cause hypotheses, technical forecasts, research conclusions
- User asks: "red-team this", "second opinion", "are you sure?", "adversarial review", "debate this"
- User challenges your confidence on something consequential
- **Not for:** low-stakes factual lookups, simple code edits, or routine pre-merge diff review

## Prerequisites

### Project permissions (`.claude/settings.json`)

Add or merge this block in the repo's **project-level** `.claude/settings.json` so Agent panelists and `codex exec` run without per-call approval prompts. Preserve any existing `hooks` or other keys — only add or extend `permissions.allow`.

```json
"permissions": {
  "allow": [
    "Agent",
    "Bash(codex *)"
  ]
}
```

- **Project-level** (this file) is preferred when the skill lives in the repo; it travels with the team via git.
- **User-level** (`~/.claude/settings.json`) is optional if you want the same allowlist in every Claude project — do not duplicate in both unless intentional.
- Restart or start a new Claude Code session after editing settings.

The skill frontmatter also declares `allowed-tools: Agent Bash(codex *)`; that applies when the skill is active and **after workspace trust** is accepted.

### Codex CLI (optional Tier 1 panelist)

- **Installed and authenticated:** `codex --version`; `~/.codex/auth.json` from `codex login`, or `CODEX_API_KEY` for automation-only runs. Separate from the Codex Claude plugin (`codex@openai-codex`).
- **`CLAUDE_CODE_SUBAGENT_MODEL`:** if set in the environment, it overrides per-panelist `model` on Agent — disclose in synthesis.

## Reference modules

Resolve paths from `${CLAUDE_SKILL_DIR}` before reading any file below.

| Module | Read when |
|---|---|
| [references/invariants.md](references/invariants.md) | Starting any panel — decorrelation, verification advantage, three invariants |
| [references/protocol.md](references/protocol.md) | Running rounds 0–3 and synthesis |
| [references/claude-dispatch.md](references/claude-dispatch.md) | Spawning panelists via Agent; optional Codex CLI |
| [references/panelist-prompts.md](references/panelist-prompts.md) | Copying prompts into Agent or Codex calls |
| [references/validation-gate.md](references/validation-gate.md) | After Round 1 returns |
| [references/failure-modes.md](references/failure-modes.md) | When something looks off mid-panel |

## Quick start

1. Read **invariants** and **protocol**.
2. **Round 0** — Triage. If panel warranted, write a self-contained brief.
3. **Recruit panelists** per [claude-dispatch.md](references/claude-dispatch.md):
   - Tier 1: Codex CLI (cross-vendor) if `codex --version` succeeds
   - Tier 2: different Claude `model` on Agent
   - Tier 3: same model, forced methodological divergence
4. **Round 1** — Launch panelists in parallel (Agent and/or Codex). Run **validation gate** on every return.
5. **Round 2** — Cross-critique in parallel.
6. **Round 3** — Final positions in parallel (or merge 2+3 for cheap 2-panelist runs).
7. **Synthesis** — Agreements / live disagreements / calibrated conclusion. Report actual heterogeneity tier.

Default: **2 panelists × 3 rounds**.

## Facilitator rules

- You are the facilitator. Keep your opinions out of the panel's mouth.
- If you add a view, label it **Facilitator view**.
- Never present synthesis as unanimous when it was not.
- Never cite the panel as authority for a view that is actually yours.
- Conduct the panel in **English**.

## Codex panelist (optional Tier 1)

Codex is an optional cross-vendor panelist via Bash, not the Codex Claude plugin.

```bash
codex --version 2>/dev/null || echo "codex not available"

OUT="/tmp/adversarial-multi-model-review-$(uuidgen | tr '[:upper:]' '[:lower:]').md"
codex exec --ephemeral -s read-only -m "${CODEX_MODEL:-}" \
  "YOUR PANELIST PROMPT HERE" \
  -o "$OUT" </dev/null
```

- **`</dev/null` is mandatory** in Claude Code's non-TTY Bash — without it, Codex waits on stdin and hangs.
- **Read `$OUT`** for the validation gate — never treat the launch command or stderr progress as the answer.
- Omit `-m` to use the default from `~/.codex/config.toml`.
- For long prompts, write the prompt to a file and pass its contents as the positional argument (avoid heredoc pipes unless `Bash(cat *)` is allowed).

If Codex is unavailable or fails twice, fall back to Tier 2 or 3 without blocking the panel.

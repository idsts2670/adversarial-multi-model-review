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
---

# Adversarial Multi-Model Review

Multi-model adversarial mutual review for Cursor. Several models answer independently, attack each other's answers, revise under critique, and the facilitator (main session) synthesizes the result. English only.

## Host routing

| Host | Dispatch module |
|---|---|
| **Cursor** (Task tool available) | [references/cursor-dispatch.md](references/cursor-dispatch.md) |
| **Claude Code** / terminal-only | [references/claude-code-dispatch.md](references/claude-code-dispatch.md) |

## When to use

- Architecture decisions, root-cause hypotheses, technical forecasts, research conclusions
- User asks: "red-team this", "second opinion", "are you sure?", "adversarial review", "debate this"
- User challenges your confidence on something consequential
- **Not for:** low-stakes factual lookups, simple code edits, or routine pre-merge diff review

## Reference modules

`cd` into this skill's directory first (resolve the path from your skill descriptor) before reading any file below.

| Module | Read when |
|---|---|
| [references/invariants.md](references/invariants.md) | Starting any panel — decorrelation, verification advantage, three invariants |
| [references/protocol.md](references/protocol.md) | Running rounds 0–3 and synthesis |
| [references/cursor-dispatch.md](references/cursor-dispatch.md) | Cursor — Task panelists; optional Codex CLI |
| [references/claude-code-dispatch.md](references/claude-code-dispatch.md) | Claude Code — optional Antigravity/Codex CLI |
| [references/blocked-integrations.md](references/blocked-integrations.md) | Before any external CLI — auth and Cursor anti-patterns |
| [references/panelist-prompts.md](references/panelist-prompts.md) | Copying prompts into Task/CLI calls |
| [references/validation-gate.md](references/validation-gate.md) | After Round 1 returns |
| [references/failure-modes.md](references/failure-modes.md) | When something looks off mid-panel |

## Quick start

1. Read **invariants** and **protocol**.
2. **Round 0** — Triage. If panel warranted, write a self-contained brief.
3. **Recruit panelists** per your host dispatch module:
   - **Cursor:** Tier 1 Task — **required slugs** `gemini-3.1-pro` (A) + `gpt-5.6-sol-high` (B); set `model` on every Task call — see [cursor-dispatch.md](references/cursor-dispatch.md)
   - **Claude Code:** optional `agy` or Codex per [claude-code-dispatch.md](references/claude-code-dispatch.md)
4. **Round 1** — Launch panelists in parallel. Run **validation gate** on every return.
5. **Round 2** — Cross-critique in parallel.
6. **Round 3** — Final positions in parallel (or merge 2+3 for cheap 2-panelist runs).
7. **Synthesis** — Agreements / live disagreements / calibrated conclusion. Report actual heterogeneity tier.

Default: **2 panelists × 3 rounds**.

## Anti-Patterns & Facilitator Rules

- **NEVER** launch Task panelists without the `model` parameter set to the required slug.
- **NEVER** substitute Claude/Opus for the OpenAI panelist (`gpt-5.6-sol-high`) unless the user overrides or the documented GPT fallback chain is exhausted.
- **NEVER** present synthesis as unanimous when it was not.
- **NEVER** cite the panel as authority for a view that is actually yours.
- **NEVER** trigger external CLI OAuth/login from an agent shell.
- You are the facilitator. Keep your opinions out of the panel's mouth.
- If you add a view, label it **Facilitator view**.
- Conduct the panel in **English**.

## External CLIs (optional)

Not required. Read [blocked-integrations.md](references/blocked-integrations.md) first.

**Codex** (OpenAI family, Cursor or Claude Code):

```bash
codex --version 2>/dev/null || echo "codex not available"
# Replace $PROMPT with the actual panelist prompt
codex exec "$PROMPT" </dev/null
```

**Antigravity** (`agy`) — **Claude Code only**; in Cursor use Task with `gemini-*` instead. Requires one-time auth in a human terminal. See [claude-code-dispatch.md](references/claude-code-dispatch.md).

Redirect stdin with `</dev/null` when spawning Codex from a non-TTY shell. If unavailable, fall back to Tier 2 or 3 without blocking the panel.

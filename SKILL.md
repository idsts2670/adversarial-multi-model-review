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

## When to use

- Architecture decisions, root-cause hypotheses, technical forecasts, research conclusions
- User asks: "red-team this", "second opinion", "are you sure?", "adversarial review", "debate this"
- User challenges your confidence on something consequential
- **Not for:** low-stakes factual lookups, simple code edits, or routine pre-merge diff review

## Reference modules

| Module | Read when |
|---|---|
| [references/invariants.md](references/invariants.md) | Starting any panel — decorrelation, verification advantage, three invariants |
| [references/protocol.md](references/protocol.md) | Running rounds 0–3 and synthesis |
| [references/cursor-dispatch.md](references/cursor-dispatch.md) | Spawning panelists via Task; optional Codex CLI |
| [references/panelist-prompts.md](references/panelist-prompts.md) | Copying prompts into Task calls |
| [references/validation-gate.md](references/validation-gate.md) | After Round 1 returns |
| [references/failure-modes.md](references/failure-modes.md) | When something looks off mid-panel |

## Quick start

1. Read **invariants** and **protocol**.
2. **Round 0** — Triage. If panel warranted, write a self-contained brief.
3. **Recruit panelists** per [cursor-dispatch.md](references/cursor-dispatch.md):
   - Tier 1: different model family or optional Codex CLI (if `codex --version` succeeds)
   - Tier 2: different Cursor `model` on Task
   - Tier 3: same model, forced methodological divergence
4. **Round 1** — Launch panelists in parallel (Task and/or Codex). Run **validation gate** on every return.
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

## Codex (optional)

Codex is an optional Tier 1 panelist, not a requirement.

```bash
codex --version 2>/dev/null || echo "codex not available"
codex exec "your panelist prompt here" </dev/null
```

Redirect stdin with `</dev/null` when spawning from a non-TTY shell (e.g. Cursor agent). If unavailable, fall back to Tier 2 or 3 without blocking the panel.

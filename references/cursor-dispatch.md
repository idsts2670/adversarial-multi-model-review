# Cursor dispatch

How to recruit and run panelists in Cursor using the **Task** tool and optional **Codex CLI**.

## Roles

| Role | Who | Duties |
|---|---|---|
| **Facilitator** | Main session (you) | Frame, dispatch, validate, synthesize. Label your own views as "Facilitator view" — never launder them through panelists. |
| **Panelists** | Task subagents (2–4) and/or Codex CLI | Independent answers, cross-critique, final positions |

## Panelist recruitment (descending heterogeneity)

Pick the highest tier available. Report the **actual** tier used in synthesis.

### Tier 1 — Different model family (preferred)

- Spawn a Task subagent with a different `model` slug when available (e.g. GPT, Gemini, Composer variants).
- **Optional:** Codex CLI via Shell if installed — check first:

```bash
codex --version 2>/dev/null || echo "codex not available"
```

If Codex is available, use **non-interactive** mode in the **foreground**:

```bash
OUT="/tmp/adversarial-multi-model-review-${PANELIST_LABEL}-r${ROUND}.md"
codex exec --ephemeral -s read-only -m "${CODEX_MODEL:-}" \
  "PASTE ROUND-SPECIFIC PANELIST PROMPT HERE" \
  -o "$OUT" </dev/null
```

- **`</dev/null` is mandatory** in Cursor's non-TTY shell — without it, Codex blocks on stdin.
- **Wait for exit 0** (generous timeout, e.g. 10 minutes). Never background the call.
- **Validate `$OUT`**, not stderr progress lines. See [validation-gate.md](validation-gate.md).
- **Long prompts:** write prompt to a temp file, then `codex exec ... "$(cat "$PROMPT_FILE")" -o "$OUT" </dev/null`.

If Codex fails twice, drop that panelist, continue, and disclose in synthesis.

### Tier 2 — Different Cursor models

Use the Task tool `model` parameter to vary models within Cursor's available set. Prefer different families over different sizes of the same family.

### Tier 3 — Same model, forced methodological divergence

When only one model family is available, assign distinct methods (not just tones):

| Panelist | Method |
|---|---|
| A | First principles — derive from fundamentals only |
| B | Base rates / outside view — anchor on reference class and priors |
| C | Disconfirming evidence only — hunt reasons the claim fails |
| D | Verification executor — re-run verifiable claims (code, math, sources) |

A role name like "Red Team" does **not** decorrelate errors. Only different models, different methods, or actual reproduction do.

## Spawning panelists (Task)

Use **Task** with `subagent_type: "generalPurpose"` unless a narrower type fits (e.g. `explore` for codebase-heavy questions).

Each Task prompt must include:

1. Role label (Panelist A/B/C and assigned method or model)
2. The self-contained brief (copied inline — not a file path to conversation context)
3. Round-specific instructions from [panelist-prompts.md](panelist-prompts.md)
4. Explicit isolation rule: "You have not seen other panelists' answers" (Round 1) or the specific peer answers (Rounds 2–3)
5. `readonly: true` when the panelist should not edit files

### Parallel launch

Launch all panelists for a round in a **single message** with multiple Task calls when possible.

Use `run_in_background: true` for long runs. On resume, treat every completion as collect → validate → continue. Never declare the panel finished while a round is incomplete.

### No Task tool available

Run panelists as sequential, strictly separated inline sections. Write each Round 1 section without re-reading the others. Note in synthesis that independence is weaker (shared weights and shared context).

## Degradation modes

| Condition | Action |
|---|---|
| No Task tool | Sequential inline sections; disclose weaker independence |
| Only one model family | Force Tier 3 methods; downgrade convergence evidence |
| Codex CLI unavailable | Skip Tier 1 CLI; use Tier 2 or 3 |
| Panelist fails twice | Drop panelist; continue; disclose actual panel composition |

## Facilitator capture guard

If you add your own view during synthesis, prefix it:

```text
Facilitator view: ...
```

Keep it separate from panel consensus. Do not attribute your prior opinion to "the panel."

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

Spawn **Task** subagents with different `model` slugs when available:

- `gemini-*` for Google/Gemini family
- `gpt-*` or Composer variants for OpenAI/other families

Prefer cross-family pairs (e.g. Gemini + GPT) over same-family duplicates.

### External CLIs (optional)

Use only when Task cannot provide the model family you need.

**Codex CLI** (OpenAI family):

```bash
codex --version 2>/dev/null || echo "codex not available"
```

If Codex is available, use **non-interactive** mode in the **foreground**:

```bash
# Replace $PROMPT with the actual panelist prompt
codex exec "$PROMPT" </dev/null
```

- Redirect stdin with `</dev/null` when the prompt is a positional argument and the agent shell is non-TTY (avoids hangs).
- Use a generous timeout (e.g. 10 minutes). Never background the call and treat the launch line as the answer.
- For long prompts, pipe from a heredoc (do not add `</dev/null` — it overrides the pipe): `cat <<'EOF' | codex exec -`

If Codex fails twice, drop that panelist, continue, and disclose in synthesis.

**Antigravity CLI (`agy`):** **Not for Cursor.** For Gemini panelists, use Task with `gemini-*` instead. Claude Code users: see [claude-code-dispatch.md](claude-code-dispatch.md). Do not trigger `agy` OAuth from agent shells — see [blocked-integrations.md](blocked-integrations.md).

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

Run panelists as sequential, strictly separated inline sections, or read [claude-code-dispatch.md](claude-code-dispatch.md). Note in synthesis that independence is weaker (shared weights and shared context).

## Degradation modes

| Condition | Action |
|---|---|
| No Task tool | Sequential inline sections or claude-code-dispatch; disclose weaker independence |
| Only one model family | Force Tier 3 methods; downgrade convergence evidence |
| Codex CLI unavailable | Skip Tier 1 CLI; use Tier 2 or 3 |
| External CLI empty stdout (exit 0) | Hard failure; validation gate; do not advance rounds |
| Panelist fails twice | Drop panelist; continue; disclose actual panel composition |

## Facilitator capture guard

If you add your own view during synthesis, prefix it:

```text
Facilitator view: ...
```

Keep it separate from panel consensus. Do not attribute your prior opinion to "the panel."

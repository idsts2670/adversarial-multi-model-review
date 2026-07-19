# Claude dispatch

How to recruit and run panelists in Claude Code using the **Agent** tool and optional **Codex CLI** via Bash.

## Roles

| Role | Who | Duties |
|---|---|---|
| **Facilitator** | Main session (you) | Frame, dispatch, validate, synthesize. Label your own views as "Facilitator view" — never launder them through panelists. |
| **Panelists** | Agent subagents (2–4) and/or Codex CLI | Independent answers, cross-critique, final positions |

## Environment checks (before Round 1)

```bash
codex --version 2>/dev/null || echo "codex not available"
printenv CLAUDE_CODE_SUBAGENT_MODEL 2>/dev/null || true
```

- If `CLAUDE_CODE_SUBAGENT_MODEL` is set, all Agent panelists may run that model regardless of Tier 2 — **disclose in synthesis**.
- Codex auth: requires `~/.codex/auth.json` from prior `codex` login, or `CODEX_API_KEY` for that invocation only.

## Panelist recruitment (descending heterogeneity)

Pick the highest tier available. Report the **actual** tier used in synthesis.

### Tier 1 — Cross-vendor (Codex CLI)

Use when `codex --version` succeeds. This is the primary way to get a non-Claude model family in Claude Code.

**Canonical invocation** (foreground, read-only, captured output):

```bash
OUT="/tmp/adversarial-multi-model-review-${PANELIST_LABEL}-r${ROUND}.md"
codex exec --ephemeral -s read-only \
  -m "${CODEX_MODEL:-}" \
  "PASTE ROUND-SPECIFIC PANELIST PROMPT HERE" \
  -o "$OUT" </dev/null
```

Rules:

- **`</dev/null` is mandatory** in Claude Code's non-TTY Bash. Without it, Codex blocks on stdin.
- **Wait for exit 0** (generous timeout, e.g. 10 minutes). Never background the call.
- **Validate `$OUT`**, not stderr progress lines. See [validation-gate.md](validation-gate.md).
- **`-m`** sets Codex's model (heterogeneity). Omit to use `~/.codex/config.toml` default.
- **Long prompts:** write prompt to a temp file, then `codex exec ... "$(cat "$PROMPT_FILE")" -o "$OUT" </dev/null`. Avoid `cat <<'EOF' | codex exec -` unless `Bash(cat *)` is in your allowlist.

If Codex fails twice, drop that panelist, continue, and disclose in synthesis.

### Tier 2 — Different Claude models (Agent)

Use the Agent tool `model` parameter (`sonnet`, `opus`, `haiku`, `fable`, or a full model ID). Prefer different capability tiers over cosmetic relabels of the same weights.

Blocked when `CLAUDE_CODE_SUBAGENT_MODEL` is set — note the override in synthesis.

### Tier 3 — Same model, forced methodological divergence

When only one model family is available, assign distinct methods (not just tones):

| Panelist | Method |
|---|---|
| A | First principles — derive from fundamentals only |
| B | Base rates / outside view — anchor on reference class and priors |
| C | Disconfirming evidence only — hunt reasons the claim fails |
| D | Verification executor — re-run verifiable claims (code, math, sources) |

A role name like "Red Team" does **not** decorrelate errors. Only different models, different methods, or actual reproduction do.

## Spawning panelists (Agent)

Use the **Agent** tool unless a narrower subagent type fits the question (e.g. codebase exploration for repo-heavy briefs).

Each Agent prompt must include:

1. Role label (Panelist A/B/C and assigned method or model)
2. The self-contained brief (copied inline — not a file path to conversation context)
3. Round-specific instructions from [panelist-prompts.md](panelist-prompts.md)
4. Explicit isolation rule: "You have not seen other panelists' answers" (Round 1) or the specific peer answers (Rounds 2–3)
5. Restrict write access when the panelist should not edit files (read-only / explore-only mode when your host supports it)

### Parallel launch

Launch all panelists for a round in a **single message** with multiple Agent calls when possible.

If panelists run as **background agents**, you may be paused and re-invoked as each completes: treat every resume as collect → validate → continue. Never declare the panel finished while a round is incomplete.

If a panelist's result seems missing, check its output file or agent transcript rather than waiting indefinitely.

### No Agent tool available

Run panelists as sequential, strictly separated inline sections. Write each Round 1 section without re-reading the others. Note in synthesis that independence is weaker (shared weights and shared context).

## Mixed panels (Agent + Codex)

Common pattern: Panelist A = Codex (`codex exec`), Panelist B = Claude Agent (`model: opus`). Launch both in parallel when possible. Validate each return independently before Round 2.

## Degradation modes

| Condition | Action |
|---|---|
| No Agent tool | Sequential inline sections; disclose weaker independence |
| Only one model family | Force Tier 3 methods; downgrade convergence evidence |
| Codex CLI unavailable or unauthenticated | Skip Tier 1 CLI; use Tier 2 or 3 |
| `CLAUDE_CODE_SUBAGENT_MODEL` set | Disclose; Tier 2 heterogeneity may be illusory |
| Panelist fails twice | Drop panelist; continue; disclose actual panel composition |

## Facilitator capture guard

If you add your own view during synthesis, prefix it:

```text
Facilitator view: ...
```

Keep it separate from panel consensus. Do not attribute your prior opinion to "the panel."

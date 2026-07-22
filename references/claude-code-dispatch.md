# Claude Code dispatch

How to recruit and run panelists in **Claude Code** (or other terminal-only hosts without Cursor Task).

> **Primary audience:** Claude Code and agents without the Cursor Task tool.
>
> **Cursor users:** use [cursor-dispatch.md](cursor-dispatch.md) instead. For Google/Gemini panelists in Cursor, use Task with a `gemini-*` model — **do not** use Antigravity CLI (`agy`); it adds the same model family with more setup and no decorrelation benefit.

## Roles

| Role | Who | Duties |
|---|---|---|
| **Facilitator** | Main session (you) | Frame, dispatch, validate, synthesize. Label your own views as "Facilitator view". |
| **Panelists** | External CLIs and/or isolated inline sessions (2–4) | Independent answers, cross-critique, final positions |

## One-time auth (Antigravity) — human terminal only

Complete this **once** in Terminal.app (or iTerm) — **never** from an agent shell:

```bash
agy -p "Reply with exactly: AGY_OK"
```

1. Run the command above in a **real terminal** (not Cursor agent).
2. Complete browser sign-in when prompted.
3. **Paste the authorization code into that same terminal** before the timeout.
4. Confirm you see `AGY_OK`.

After this, `agy -p` may work headless from agent shells on the same machine (tested: `agy` 1.1.5 on macOS). If auth is re-prompted, repeat in a human terminal — **do not** loop OAuth from the agent.

## Panelist recruitment (descending heterogeneity)

Report the **actual** tier used in synthesis.

### Tier 1 — Different model family (preferred)

**Antigravity CLI** (Google agent harness) — optional if installed:

```bash
agy --version 2>/dev/null || echo "agy not available"
```

Headless panelist invocation (after one-time auth above):

```bash
# Replace $PROMPT with the actual panelist prompt
agy --mode plan -p "$PROMPT"
```

- Use `--mode plan` for review-only panels (no file edits).
- Prefer `--sandbox` when available for extra isolation.
- Foreground only; generous timeout (e.g. 10 minutes).
- Run [validation-gate.md](validation-gate.md) on every return.
- If paired with another Gemini-family panelist, report **same-family duplicate** and downgrade convergence evidence in synthesis.

**Codex CLI** (OpenAI family) — optional alternate:

```bash
codex --version 2>/dev/null || echo "codex not available"
# Replace $PROMPT with the actual panelist prompt
codex exec "$PROMPT" </dev/null
```

For long Codex prompts: `cat <<'EOF' | codex exec -` (do not add `</dev/null` — it overrides the pipe).

If either CLI fails twice, drop that panelist, continue, and disclose in synthesis.

### Tier 2 — Different models via host subagents

If your host supports subagents with different `model` parameters, use them like Cursor Task. Prefer different families over different sizes of the same family.

### Tier 3 — Same model, forced methodological divergence

| Panelist | Method |
|---|---|
| A | First principles |
| B | Base rates / outside view |
| C | Disconfirming evidence only |
| D | Verification executor — re-run verifiable claims |

## Spawning panelists (inline / subagent)

When no external CLI is available, run panelists as **strictly separated** inline sections or subagent calls:

1. Role label + self-contained brief (inline — not a conversation file path)
2. Round-specific instructions from [panelist-prompts.md](panelist-prompts.md)
3. Isolation rule: blind in Round 1; specific peer answers in Rounds 2–3
4. Read-only / no file edits for review panels

## Degradation modes

| Condition | Action |
|---|---|
| `agy` not installed or auth not completed | Skip; use Codex or Tier 2/3 |
| `agy -p` empty stdout or auth re-prompt | Hard failure per validation gate; do not advance rounds |
| Codex unavailable | Skip; use `agy` or Tier 2/3 |
| Only one model family | Force Tier 3 methods; downgrade convergence evidence |
| Panelist fails twice | Drop; disclose actual panel composition |

## Install

[Antigravity CLI](https://github.com/google-antigravity/antigravity-cli) is optional. Install in a **human terminal** only — never pipe remote scripts to a shell from an agent session.

**macOS (recommended):** Homebrew cask (version-pinned artifact with SHA256 verification):

```bash
brew install --cask antigravity-cli
agy --version
```

Binary: `/opt/homebrew/bin/agy` on Apple Silicon, `/usr/local/bin/agy` on Intel.

**Linux / other:** follow [official install docs](https://antigravity.google/docs/cli/overview). Script install places the binary at `~/.local/bin/agy`; add that directory to `PATH` if `agy` is not found.

# Blocked or discouraged integrations

Patterns that **must not** be used as panelists without meeting preconditions below.

## Antigravity CLI (`agy`) in Cursor

**Do not use `agy` as a Gemini panelist in Cursor.**

Cursor Task already supports `gemini-*` model slugs with less setup and the same model family. Using `agy` + Task Gemini is **same-family duplication**, not Tier 1 decorrelation.

**Cursor path:** [cursor-dispatch.md](cursor-dispatch.md) — Task with `gemini-*`, `gpt-*`, or optional Codex CLI.

**Claude Code path:** [claude-code-dispatch.md](claude-code-dispatch.md) — `agy -p` after one-time human-terminal auth.

## Agent-triggered `agy` OAuth

**Never** run `agy` login or first-time `agy -p` from a Cursor/Claude agent shell to complete OAuth.

The CLI prompts for a pasted authorization code; agent shells cannot provide it. Each attempt starts a new browser OAuth flow and times out.

Complete auth once in a **human terminal** (see claude-code-dispatch.md), then optionally use `agy -p` headlessly.

## External CLI hard failures

Treat as **invalid panelist output** (do not advance to the next round):

- Exit 0 with **empty or whitespace-only stdout**
- Auth re-prompt text without a substantive answer
- Hang past timeout
- Status/error-only output

See [validation-gate.md](validation-gate.md).

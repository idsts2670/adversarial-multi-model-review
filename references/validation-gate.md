# Validation gate

Run immediately after Round 1 (and after any panelist retry). **Do not skip.**

## What counts as a valid contribution

A substantive answer that addresses the brief: claims, reasoning, confidence, and falsification conditions where required.

## What is NOT a valid contribution

Reject and re-run (or drop after two failures):

- Status lines ("task started in background", "running…")
- Tool notifications or empty acknowledgments
- Error dumps without a substantive answer
- Copy-paste of the brief without analysis
- Meta-commentary about being an AI panelist

If invalid text enters the record, later rounds critique a **ghost panelist** and the panel silently degrades.

## Checklist per panelist return

1. Does the text address the question in the brief?
2. Does it contain at least one substantive claim or reasoned "cannot answer"?
3. Is it free of status/error-only content?
4. For Round 1: was this panelist blind to other answers?

If any check fails → re-run that panelist once with a stricter prompt emphasizing substantive output.

If it fails twice → drop to the next heterogeneity tier or continue with fewer panelists. **Disclose the actual panel** in synthesis.

## External CLI panelists

- Require **foreground** execution; wait for completion.
- Use a generous timeout (e.g. 10 minutes for heavy tasks).
- Never background the CLI call and treat the launch message as the answer.
- Capture stdout/stderr; if only errors return, treat as failure.
- **Hard failure:** exit 0 with empty or whitespace-only stdout — treat as invalid; **do not advance to the next round** (ghost panelist).
- **Hard failure:** OAuth/auth re-prompt text without a substantive answer.
- If output is only ANSI escape codes, strip before validation.

## Minimum viable panel

- Prefer 2 panelists. If only 1 valid panelist remains after retries, either:
  - Abort the panel and answer directly with explicit uncertainty, or
  - Continue with 1 panelist + facilitator-labeled critique (disclose severely weakened decorrelation).

Default: abort or ask the user unless they explicitly want a degraded single-panelist run.

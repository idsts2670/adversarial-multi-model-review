# Failure modes and countermeasures

All observed in practice. The protocol exists to prevent these.

| Failure mode | Symptom | Countermeasure |
|---|---|---|
| **Ghost panelist** | Status/error string enters the record; later rounds debate thin air | [validation-gate.md](validation-gate.md) after Round 1; foreground CLI |
| **Sycophantic convergence** | Unanimous agreement by Round 2 with no new arguments (mode collapse) | "You disagree with at least one central claim; find it" in Round 2 |
| **Facilitator capture** | Moderator launders prior opinion through panel authority | Label facilitator views; never attribute your view to the panel |
| **Confidence theater** | Numeric confidence without falsification condition | Treat as missing; require checkable falsifiers |
| **Diversity illusion** | Same-model personas treated as independent reviewers | Report same-family convergence as weak evidence; prefer Tier 1–2 |
| **Triage trap** | Confidently wrong tasks skip the panel at Round 0 | User-requested panel always runs; stakes-based triage for consequential questions |
| **False balance** | Symmetric "both views" when one side has reproducible evidence | Adjudicate by evidence strength in synthesis |
| **Averaging** | Splitting the difference between panelists | Preserve disagreements; adjudicate explicitly ([invariants.md](invariants.md)) |

## When to stop the panel early

- User cancels or narrows scope
- Brief is ill-posed — return to Round 0 and rewrite the brief
- Fewer than 2 valid panelists after retries and user does not want degraded mode
- Question resolved trivially in Round 1 with unanimous verifiable agreement **and** heterogeneous panel (rare; still run validation gate)

## Audit trail in synthesis

Always report:

- Which panelists actually ran (model/method/CLI)
- Which heterogeneity tier was achieved
- Which critiques you accepted or rejected and why
- Whether convergence is strong or weak evidence

# Three Invariants

Protect these throughout every round. If any invariant breaks, stop and repair before continuing.

| Invariant | Meaning |
|---|---|
| **Independence** | Round 1 answers are generated blind. A panelist that has seen another answer anchors on it and is no longer an independent sample. |
| **Adversariality** | Agreement without a new argument is a failed round. Force disagreement when panelists converge too quickly. |
| **No averaging** | Synthesis is not averaging. Preserve and adjudicate disagreements — splitting the difference destroys the signal. |

## Design properties (why the panel works)

Running multiple models is not enough. The benefit comes from:

- **Decorrelation** — Reviewers only catch what the generator missed when their error modes differ. Same-model panels share blind spots, so confident convergence is weaker evidence than it looks. Cross model families when possible.
- **Verification advantage** — Refuting a given answer is often easier than producing one. Point critics at verifiable claims: not "this seems dubious" but "this fails on input X". Refute by reproduction, not by assertion.

## GAN correspondence

| GAN (training time) | adversarial-multi-model-review (inference time) |
|---|---|
| Generator | Panelists' independent answers (Round 1) |
| Discriminator | The attacking side of cross-critique (Round 2) |
| Gradient updates | Natural-language critique, reasoned concession and defense (Round 3) |
| Minimax equilibrium | Facilitator's adjudicated synthesis |
| Discriminator's advantage | Verification asymmetry — spotting flaws is easier than creating |
| No weight sharing | Model-family separation — decorrelated errors |
| Mode collapse | Mutual-agreement equilibrium (sycophantic convergence) |
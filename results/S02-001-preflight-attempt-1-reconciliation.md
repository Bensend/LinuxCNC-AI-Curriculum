# S02-001 — frozen observability preflight attempt 1 reconciliation

Date: 2026-09-09
Workflow: `34394006626`
Job: `102609072085`
Job runtime: 2026-09-09T19:15:49Z–2026-09-09T19:19:15Z = 3.4 min
Source commit: `b539488a56c1cbf745ef7b3afe5feef953fbf06b`
Frozen S02 model: P0–P5 and Gates A–J in `guides/S02-feedback-integrity-common-cause-research.md`

## Classification

**HARNESS INVALID — pre-behavior HAL identifier mismatch.** Frozen Gates A–J remain **UNSCORED**. No P0–P5 behavioral conclusion is permitted from this run.

## What reached valid execution

- pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413` cloned and built;
- the S02 test-only `.comp` compiled/installed successfully enough for `loadrt s02_model` to proceed;
- predeclared numeric/model contract was printed before runtime;
- LinuxCNC entered the POSIX non-realtime fallback used by prior software-only laboratory fixtures.

## Failure

The HAL file stopped at:

```text
HAL: ERROR: function 's02_model.0' not found
/tmp/s02.hal:4: addf failed
```

The source of the mismatch is `halcompile` identifier normalization. In a `.comp` HAL identifier, underscores are converted to hyphens. `component s02_model` therefore exports HAL object/function names beginning `s02-model`, while the harness tried to address `s02_model.0`.

This is a harness namespace defect, not a failed S02 prediction. The module/file token for `loadrt s02_model` is retained; only exported HAL object references need `s02-model.0`.

## Allowed correction

Create attempt 2 by replacing only exact exported-HAL-object references `s02_model.0` -> `s02-model.0`. Do **not** change:

- P0–P5 semantics;
- Gates A–J;
- 1 ms servo period;
- 200-cycle phase length;
- 0.050 disagreement/stale thresholds;
- P1 0.200 offset or <=1-cycle detector bound;
- P2 0.002 units/cycle ramp or <=30-cycle stale bound;
- P3 UNKNOWN classification;
- P4 restricted-detector input contract;
- P5 limited-diagnostic interpretation.

Attempt 1 counts as the first materially similar implementation/preflight attempt under the three-attempt rule.

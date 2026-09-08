# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05 — custom operator interface patterns**, **C01 — simulated dual-actuator machine**, **C02 — independent feedback loops**, and **C03 — explicit cross-coupling** are **GRADUATED at 1000 level**.

Phase 10 remains active. The highest-priority unblocked module is **C04 — asymmetric actuator response**, state **CORRECTIONS**.

C03 graduation evidence is committed in `evaluation/C03-1000-graduation-evaluation.md`: the pre-frozen adversarial exam scored 10/10, the novel saturation+sensor/plant-asymmetry handoff passed, the promotion/counterfactual audit passed, and the accepted C03-025 result remains bounded to the pinned deterministic fixture.

## Blind development baseline — BL-DEV-001

The learner response was immutably committed in `evaluation/development/BL-DEV-001-precommit.md` at commit `2117ac7103f929a0d90b59551785500d2b59b874` before oracle inspection.

Result: **VALID, 10/10, 92% confidence**. Detailed evaluation is in `evaluation/development/BL-DEV-001-evaluation.md`; the score ledger is `evaluation/FEEDBACK_SCORE_LOG.md`.

A novel retention/development challenge should sample a different mechanism after roughly 10 subsequent lessons or about 24 hours, preserving the actual delay.

## C01 — simulated dual-actuator machine — GRADUATED 1000

Accepted C01-023: workflow `34209185893`, job `102005842122`, artifact `10049218375`, inner exit `0`, Gates A-H PASS. Realtime sampling observed 5 inches of movement on both duplicated Y commands with `max-abs-j1-j3-command-diff=0` and zero sampler overruns.

Retained boundary:

```text
same coordinated command
!= same observation instant
!= independent feedback agreement
!= same physical position
!= synchronized plant
!= safety-rated protection
```

Graduation evidence: `evaluation/C01-1000-graduation-evaluation.md`.

## C02 — independent feedback loops — GRADUATED 1000

C02 established that two PID instances receiving a common command retain separate command/feedback/error/output state and can diverge under an asymmetric plant disturbance.

Retained boundary:

```text
shared command
!= shared feedback state
!= shared control error
!= synchronized physical plant
!= implicit cross-coupling
!= safety-rated disagreement protection
```

## C03 — explicit cross-coupling — GRADUATED 1000

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted C03-025: workflow `34228231147`, job `102067547546`, artifact `10056799485`, source commit `99f7c35ce3cfd23aa96c11f0168c798ff8607c7c`, inner exit `0`, Gates A-H PASS after two retained HARNESS INVALID phase-publication attempts.

The explicit `Kc=0.5` relative-feedback coupler reduced sustained deterministic simulated disagreement from `0.703374228 in` to `0.377045040 in` (about 46.4%); removing it raised disagreement to `0.738476396 in` (about 1.96x the coupled value). All 3013 qualified sign rows were directionally correct and sampled realtime arithmetic residuals were zero.

Graduation evidence: `evaluation/C03-1000-graduation-evaluation.md`.

Retained boundary:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

## C04 — asymmetric actuator response — CORRECTIONS

Pinned revision remains `8bf4605ae81042248add031e94c77300406e0413`.

Research/source guide: `guides/C04-asymmetric-actuator-response-research.md`. Frozen experiment: `experiments/C04-026-asymmetric-authority-plan.md`. Frozen adversarial exam: `evaluation/C04-adversarial-exam-draft.md`.

C04-026 attempt 1 authoritative workflow `34231940180`, job `102079994732`, artifact `10058317466`, source commit `5068dea32243f209e4873cc1117a1b2d5ed51dc2` is classified **HARNESS INVALID**, not behavioral FAIL. Detailed reconciliation: `results/C04-026-attempt-1-reconciliation.md`.

Attempt 1 produced 10,111 realtime samples with zero reported overruns and diagnostically showed S1=0, S2=0.377086302, S3=0.687180144, S4=0.0103899042 with exact sampled coupling arithmetic residuals. These values are not accepted gate evidence because two audit defects invalidate the decisive observation: the Gate-F analyzer checked PID-B saturation together with tuple index 8 (PID-A output) instead of tuple index 9 (PID-B output), and the raw realtime trace was not retained because the inherited evidence-copy block ran only after the failing analyzer under `set -e`.

Pinned `pid.c` reconciliation is now explicit: nonzero `maxoutput` clips only when pre-limit output exceeds the bound, sets `limit_state` on clipping, and drives `saturated` plus saturation duration/count from `limit_state`. Therefore equality of final output with the configured limit is not by itself sufficient source evidence that clipping occurred; same-cycle saturation telemetry remains required.

Retained evidence boundary under test:

```text
corrected command separation
!= available local actuator authority
!= achieved plant response
!= feedback convergence
```

and:

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

### Exact next-work checkpoint

1. Correct only the C04-026 observation harness; keep frozen Gates A-H, Kc=0.5, PID gains, plant gains, maxoutput=1.0, phase durations, and thresholds unchanged.
2. Fix Gate-F PID-B output indexing from tuple `r[8]` to `r[9]`.
3. Preserve/copy `c04-026-realtime.txt`, stdout/stderr, metadata and exit evidence before any analyzer can terminate the script; verify the next workflow artifact actually contains the raw trace.
4. Run one authoritative C04-026 attempt 2. Inspect raw phase-3 `satB`, `satCountB`, `outB`, and `maxOutB` rows directly before trusting the summary.
5. If valid attempt 2 does not produce >=500 consecutive frozen Gate-F saturation rows, classify that as behavioral FAIL rather than retuning. If it passes, score the already-frozen exam, perform fresh-AI handoff and promotion/counterfactual audit, then graduate only if all 1000-level floors pass.
6. C05 owns frozen/scaled/jumping feedback; C04 must not infer sensor-fault cause from ordinary saturation/disagreement evidence.

## Laboratory compute / timing notes

`LAB_COMPUTE_LOG.md` contains authoritative compute accounting. Invalid runs are retained rather than hidden. C03 attempts 1-3 and C04-026 should be backfilled from authoritative job timing at the next accounting pass.

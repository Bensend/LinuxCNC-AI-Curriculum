# S02-005 — frozen 2000-level adversarial exam grade

Date: 2026-09-09
Frozen exam: `evaluation/S02-2000-adversarial-exam-frozen.md`
Immutable learner answer: `evaluation/S02-2000-adversarial-answer.md`
Exam freeze preceded authoritative-result review; learner answer was committed before this grade.

## Score

| Question | Points | Awarded | Reason |
|---|---:|---:|---|
| Q1 agreement is not truth | 3 | 3 | Correctly bounds clean transport, labels stationary sensor freshness `UNKNOWN`, rejects agreement as independence and names genuinely independent evidence classes. |
| Q2 version-pinned source path | 2 | 2 | Gives pinned hm2_eth queued-read -> receive/check -> soft-error/success path and stops evidence at board transaction rather than inventing per-encoder truth. |
| Q3 stale during motion vs stationary ambiguity | 3 | 3 | Distinguishes stale diagnosis with an independent changing oracle from stationary value-only `UNKNOWN`; clean transport is correctly orthogonal. |
| Q4 common-mode adversary | 3 | 3 | Constructs observationally identical false-agreement inputs, explains impossibility of guaranteed restricted detection, and identifies independent evidence needed to break ambiguity. |
| Q5 quadrature scope | 2 | 2 | Limits diagnostic to covered sequence/counting fault class and rejects coupling/freshness/scale/diversity/truth overclaims. |
| Q6 watchdog misleading premise | 2 | 2 | Separates watchdog/I-O authority from encoder validity and recognizes internal state may continue despite physical I/O disconnect semantics. |
| Q7 recorder adversary | 2 | 2 | Rejects exact latency proof across producer loss and requires contiguous atomic producer-side evidence; preserves only appropriately qualified qualitative claims. |
| Q8 bounded HAL design | 3 | 3 | Correct signal partition, explicit unknown state, realtime producer->monitor->consumer ordering, userspace excluded from decision and functional-safety boundary preserved. |

**Total: 20/20 — PASS.** Required threshold was 18/20.

## Critical traps

All ten frozen critical traps were explicitly rejected. None was accepted implicitly elsewhere in the answer. **Critical-trap result: PASS.**

## Corrections required

No conceptual correction loop is required from this exam. One wording caution should remain in the durable guide: `PROVEN-FRESH` is not a generic incremental-encoder state supplied by LinuxCNC; Q8 uses it only as an example state *if an independently justified architecture actually provides a freshness witness*. The answer itself already includes that qualifier, so this is reinforcement rather than a correction.

## Exam conclusion

The learner demonstrated the 2000-level target distinction among value agreement, board-transport health, sensor freshness, channel diagnostics, diversity/common-cause independence and physical truth, and preserved both realtime evidence-integrity and functional-safety boundaries.

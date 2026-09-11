# F02-001 authoritative audit

Status: **PASS / TECHNICAL EVIDENCE ACCEPTED**
Date: 2026-09-11
Workflow: `34657204415`, attempt 1
Source commit: `4d3277d1d11b60cf68126c65190d7ee42886f8e8`
Job: `082-f02-compound-fault-arbitration`
Pinned LinuxCNC evidence baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Provenance

The behavioral contract and Gates A–J were frozen first in `experiments/F02-001-compound-fault-arbitration-plan.md`. The implementation was then committed separately as `lab-jobs/082-f02-compound-fault-arbitration.sh`, automatically executed by the existing lab runner, and retained under `lab-results/f02-001/`.

`lab-results/LATEST.md` records exit code 0 and all frozen gates true. `lab-results/f02-001/raw.csv` contains 19 invocation-level rows.

## Independent retained-evidence inspection

The retained CSV was inspected directly rather than accepting only the harness summary.

- `seq` is strictly monotonic 1–19 with no gap.
- P0 rows 1–2 show READY rearm followed by a fresh run request; motion authorization is false before the request and true in RUNNING.
- P1 row 3 shows transport loss changing RUNNING -> FAULTED in the same retained invocation, `motion_authorized=0`, stale command cleared, and revocation witness set. Row 4 then adds FOLLOWING_ERROR without erasing TRANSPORT_INVALID.
- P2 row 5 shows transport green again while watchdog, independent feedback revalidation and reference validity remain false; state remains FAULTED and unauthorized.
- P3 row 6 adds RECORDER_INVALID to the already-latched episode and makes `evidence_valid=0` without erasing prior observations.
- P4 row 7 shows premature explicit rearm ignored while FAULTED.
- P5 rows 8–9 enter RECONCILE only after immediate prerequisites recover, then a newly injected interlock fault forces RECONCILE -> FAULTED and adds INTERLOCK_INVALID to history.
- P6 rows 10–11 retry reconciliation and complete only after independent feedback/reference revalidation; completion lands in READY, not RUNNING, with no stale command and no rearm latch.
- P7 rows 12–14 show explicit rearm alone remains READY/unauthorized; a no-command row remains READY; only a new run request returns to RUNNING.
- P8 rows 15–16 show internally valid/agreed feedback without independent revalidation cannot complete reconciliation even when a rearm request is present.
- P9 rows 17–19 show the recorder-only degradation boundary: `RECORDER_INVALID` sets `evidence_valid=0` but, with all control prerequisites still valid, the deterministic F02 policy does not invent a motion-control revocation.

## Frozen Gates A–J

| Gate | Result | Direct retained-evidence basis |
|---|---|---|
| A nominal authority | PASS | rows 1–2 |
| B same-invocation revocation | PASS | row 3 |
| C non-destructive compound history | PASS | rows 3–6 |
| D layer separation | PASS | row 5 |
| E evidence separation | PASS | rows 6, 19 |
| F no premature rearm | PASS | row 7 |
| G reconciliation interruptible | PASS | rows 8–9 |
| H no stale auto-resume | PASS | row 11 |
| I explicit new authority | PASS | rows 12–14 |
| J common-cause boundary | PASS | rows 15–16 |

**Result: 10/10 PASS.**

## Prediction check

Predeclared prediction: a compound transport/following-error/recorder episode would retain all observations, revoke motion on invalid control prerequisites, independently degrade evidence validity on recorder failure, refuse transport-only recovery, and never replay a stale command without reconciliation + explicit rearm + a fresh request.

Observed: exact match under the deterministic contract.

Classification: **TEST-CONFIRMED for the F02 policy harness**, bounded by the evidence limits below.

## Adversarial exam

`exams/F02-adversarial-exam.md` was frozen before answers. `exams/F02-adversarial-answers-and-score.md` records **20/20 PASS**, including all four critical questions. No central correction was required.

## Corrections / limitations found during audit

No frozen behavior or gate required correction.

One wording constraint is retained as a deliberate lesson rather than a harness change: temporal ordering plus community mechanism evidence can make one cause **plausible**, but does not by itself license a universal or episode-specific source-confirmed root-cause label. F02 therefore preserves both initiating and downstream observations while bounding causal attribution.

## Graduation sufficiency / boundary

Technical 2000-level evidence is sufficient for the compound-fault integration objective because:

- prerequisite mechanisms were already source/test verified individually;
- F02 added an integration policy rather than pretending to re-simulate Ethernet, encoder mechanics or physical machines;
- official documentation, community field evidence and pinned source were reconciled in `research/F02-compound-fault-source-community-pass-2026-09-11.md`;
- F02-001 independently exercised compound observation retention, revocation, reconciliation interruption, evidence degradation and stale-command prevention under pre-frozen gates;
- the adversarial exam passed 20/20.

The result **does not** establish functional-safety performance, stopping time/distance, real Ethernet reliability, actual encoder independence, a machine-specific reconciliation procedure or physical causal root truth.

## Fresh-AI boundary

F02 is **TECHNICALLY ACCEPTED / FRESH-AI HANDOFF PENDING**, not yet graduated. A genuinely information-separated evaluator must solve the novel F02 handoff before the module and 2000 series can be declared graduated.

The learner must not self-certify that final handoff.

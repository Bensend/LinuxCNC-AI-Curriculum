# PB-BG-003 run 083 independent audit

Date: 2026-09-12
Workflow: `34664318311`
Source commit: `2f1d77fcb85ffc5188f6c96754535e9445b6e116`
Retained trace: `lab-results/pb-bg-003/raw.csv`
Frozen contract: `experiments/PB-BG-003-episode-at-position-plan.md`

## Verdict

**HARNESS INVALID / NO PB-BG-003 BEHAVIORAL PASS CLAIM.**

The workflow exited 0 and its generated analyzer reported frozen Gates A–J true over 28 monotonic rows, but independent comparison of the retained CSV to the pre-frozen contract found a material observability reduction introduced during implementation.

## What is valid in the retained trace

The retained `seq` values are strictly monotonic 1–28. The trace also visibly demonstrates the generic episode-latch mechanism:

- episode 1 completes in P0;
- same numeric target reissue creates episode 2 in P1 and does not inherit episode 1 completion;
- an abstract validity loss invalidates the episode and latches reconciliation;
- reconciliation does not resurrect an invalidated episode;
- a later raw-healthy snapshot does not erase the latched invalidation.

Those are useful harness-construction observations only.

## Defect

The frozen plan declared independent inputs for at least:

- `homed` / reference validity;
- ordinary motion authorization;
- drive validity;
- feedback validity;
- LinuxCNC joint-fault-clear state.

Frozen phases P2, P4, P5, P6 and P7 intentionally exercise those as distinct invalidation families, and frozen Gate I explicitly requires separate LinuxCNC joint-fault and ordinary-authorization revocation evidence.

Run 083 replaced all of those with one synthetic `healthy` bit. Phase labels alone do not restore the missing retained witness identity. Therefore the analyzer can say only that the same generic boolean invalidation path works repeatedly; it cannot demonstrate that the frozen distinct input channels were independently presented to the state policy.

This is a **harness/provenance defect**, not a substantive failure of the episode-state concept. The frozen phases, prediction and Gates A–J remain unchanged.

## Correction rule

Implement one corrected pure-software harness that retains the separate synthetic input columns. It must remain non-actuating and must not add motor physics, machine parameters, gains, speeds, tolerances or hardware interfaces.

The corrected trace must show:

- P2: only reference validity drops;
- P4: only drive validity drops;
- P5: only feedback validity drops for the transient;
- P6: only controller/joint-fault-clear validity drops;
- P7: only ordinary authorization drops.

All frozen Gates A–J must then be independently scored from the retained raw evidence.

## Claims boundary

Run 083 does not establish physical behavior, LinuxCNC hardware behavior, commissioned values or functional safety. It is retained as a useful failed harness attempt and compute/provenance record.

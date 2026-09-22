# 4000 Safety continuation checkpoint — 2026-09-22T05:48Z

## Durable work completed

- Added `safety-course/25E0_FINDING_DISPOSITION_CONTAINMENT_AND_COMMON_CAUSE_DEGRADATION_2026-09-22.md`.
- Added stable `FIND-*` semantics separating observation, criterion, containment, cause hypothesis, correction, re-proof, acceptance and closure.
- Professional trace: SICK stop-time measurement; Pilz safeguard inspection/validation; Rockwell diagnostics/validation boundary.
- Stress-tested common-cause degradation across apparently independent safety functions through shared physical/environmental dependencies.
- Updated `PROGRESS.md`.

## Frozen distinctions

- `FINDING RECORDED != ROOT CAUSE KNOWN`.
- `REPAIR COMPLETE != SAFETY PROPOSITION RESTORED`.
- `REPEATED TEST PASSES != ORIGINAL ADVERSE RESULT DISPOSITIONED`.
- `GREEN CONTROLLER DIAGNOSTICS != PHYSICAL MACHINE SAFE`.
- `LOGICALLY INDEPENDENT SAFETY FUNCTIONS != PHYSICALLY INDEPENDENT SAFETY FUNCTIONS`.
- `COMMON PHYSICAL DEPENDENCY != IDENTICAL REVALIDATION OBLIGATION`.

## Exact next work

1. Build a compact reusable `FIND-*`/disposition template integrated with accepted-baseline IDs.
2. Trace authoritative common-cause degradation beyond brakes: contamination, supply degradation/loss, environmental effects, or mechanical coupling.
3. Build recurrence/escalation rules so repeated findings trigger design/maintenance/proof-method/human-factors review rather than endless isolated repair.
4. Keep ordinary LinuxCNC/FPGA as diagnostic/evidence surfaces, not personnel-safety acceptance authority.
5. No compute is currently justified. If a future unresolved question requires compute, use `[self-hosted, openpressbrake]` only; never GitHub-hosted runners.

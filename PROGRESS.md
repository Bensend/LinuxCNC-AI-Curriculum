# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T13:13:21Z`
- Session end: OPEN
- Active work: D01 clean standalone evidence-retention/provenance preflight `lab-jobs/018-d01-clean-evidence-retention-preflight.sh`, workflow `34355802800`, is queued/running. Frozen numeric fixture and D01-002 Gates A-J are unchanged and unscored.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. The 1000-series critical path is complete. Highest-priority unblocked 2000-series work remains **D01 — coupled-control stability and tandem-joint authority**, state **EXPERIMENT / CLEAN EVIDENCE-RETENTION PREFLIGHT ACTIVE**.

## Blind external-feedback state

- BL-DEV-001 VALID 10/10; BL-DEV-002 VALID 9/10; BL-DEV-002-TRANSFER-01 VALID 10/10.
- Delayed retention remains separate. Preserve end-of-1000 sealed-benchmark information separation.

## D01 — coupled-control stability and tandem-joint authority

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable source model and research remain in `guides/D01-coupled-control-stability-authority-research.md`, `guides/D01-community-tandem-homing-vs-runtime-authority.md`, `call-flows/D01-duplicated-coordinate-command-feedback.md`, and `call-flows/D01-servo-cycle-feedback-ferror-fault-order.md`.

Accepted source model:

```text
duplicated Cartesian coordinate command
    -> inverse kinematics copies the coordinate to every mapped joint
process_inputs()
    -> each joint independently forms feedback, ferror and ferror limit
do_forward_kins()
    -> ordinary duplicated-coordinate trivkins reports the principal/first mapped joint
       rather than averaging or validating duplicate feedback
check_for_faults()
    -> a qualifying per-joint fault can revoke machine-wide motion authority
```

`results/D01-002-frozen-runtime-experiment.md` froze P0-P8 and Gates A-J before implementation. The original three-attempt command-driver lineage was retired. The redesigned `015 -> 016 -> 017` lineage also reached its three-attempt boundary: attempt 3 (`34350408741` / `102462004744`) validated all planned runtime numerics—duplicated Y settled at 10; low duplicate offset `0.020` yielded ferror about `-0.02` below `0.050` with no duplicate fault, principal-looking Cartesian Y and motion enabled; high offset `0.200` yielded duplicate-only ferror about `-0.2`, principal clean, Cartesian Y still 10 and global motion disabled; 2,200 atomic samples and zero overruns—but failed only during final provenance export after leaving the source repository. Gates A-J therefore remain UNSCORED.

### Clean evidence-retention redesign

A new standalone lineage begins with `lab-jobs/018-d01-clean-evidence-retention-preflight.sh`, commit `24376f64c2f0816e320a8288c09ff66130ae5744`, workflow `34355802800`.

It deliberately does not retune behavior. It keeps low/high offsets `0.020/0.200`, relevant ferror limit `0.050`, the validated `linuxcnc.command()`/NML homing+MDI path, correct `mux16.sel0..sel3/out-f`, phase-before-mutation semantics, and the test-only Cartesian observer. Its new purpose is evidence integrity: retain observer patch and pinned source revision before leaving the source tree, and package the atomic stream, collector stderr/stdout, INI/HAL, topology, thread order, LinuxCNC logs and recorder-health evidence under `lab-results/d01-018-evidence/`. It asserts nonempty observer patch and trace, zero producer overruns and empty collector stderr before declaring retention-preflight PASS.

### Exact next-work checkpoint

1. Inspect only workflow `34355802800` when complete; do not launch a duplicate while it is active.
2. If it fails, classify whether the new standalone retention lineage has a harness/evidence defect and correct only that defect; do not retune frozen runtime values or D01-002 gates.
3. If it passes, reconcile the retained artifact contents and provenance as non-authoritative evidence-retention proof.
4. Then create one separate independent authoritative D01 run using unchanged D01-002 P0-P8 and Gates A-J. Score gates from retained evidence, not live assertions.
5. Authoritative evidence must retain one atomic realtime stream, zero producer overruns, monotonic sample indices, collector stderr state, phase-before-mutation witnesses, exact observer-source diff, config/HAL/test source, startup logs, topology/order and gate-analysis output.
6. Keep F02 blocked until D01 has an accepted authority/fault-containment contract. Preserve sealed benchmark separation and delayed-retention obligation.

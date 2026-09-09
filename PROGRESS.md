# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T15:13:58Z`
- Session end: `ACTIVE`
- Active work: D01 clean evidence-retention lineage attempt 2, workflow `34362010265`, has completed successfully. Reconciling retained artifacts before any authoritative D01 run. Frozen numeric fixture and D01-002 Gates A-J remain unchanged and UNSCORED.

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

The standalone retention lineage began with `018`, workflow `34355802800`. Attempt 1 failed before runtime because its Python rewrite inserted early provenance commands and then an over-broad regex deleted every line beginning `git diff`, `git rev-parse`, or `git status`, including the newly inserted commands. Consequently `/tmp/d01-observer.patch` was never created and `cp` failed. This is a pure harness rewrite defect; it does not challenge the validated runtime fixture and does not score D01-002 gates.

Attempt 2 is `lab-jobs/019-d01-clean-retention-preflight-fix1.sh`, commit `f0cd9efed7cf82f76b300f104decdccf3e4085c6`, workflow `34362010265`. It changes only the rewrite logic: preserve the early source-tree provenance-producing commands and remove only the inherited final provenance block that executes after leaving the source tree. Runtime values remain low/high offsets `0.020/0.200`, relevant ferror limit `0.050`; NML homing/MDI, mux interface, observer placement and phase semantics are unchanged.

### Exact next-work checkpoint

1. Inspect only workflow `34362010265` when complete; do not launch a duplicate while active.
2. If it fails, classify only the retention-lineage harness/evidence defect. This is attempt 2 of the clean retention lineage; one materially similar correction remains before the three-attempt classification boundary. Do not retune runtime values or frozen gates.
3. If it passes, reconcile the retained artifact contents and provenance as non-authoritative evidence-retention proof.
4. Then create one separate independent authoritative D01 run using unchanged D01-002 P0-P8 and Gates A-J. Score gates from retained evidence, not live assertions.
5. Authoritative evidence must retain one atomic realtime stream, zero producer overruns, monotonic sample indices, collector stderr state, phase-before-mutation witnesses, exact observer-source diff, config/HAL/test source, startup logs, topology/order and gate-analysis output.
6. Keep F02 blocked until D01 has an accepted authority/fault-containment contract. Preserve sealed benchmark separation and delayed-retention obligation.

# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T15:13:58Z`
- Session end (UTC): `2026-09-09T15:18:18Z`
- Actual elapsed: `4.3 minutes`
- Active work: D01 clean evidence-retention lineage attempt 3, workflow `34369209171`, is running. Attempt 2 reproduced the validated runtime but its downloaded Actions artifact omitted the actual evidence directory; `results/D01-004-clean-retention-attempt-2-reconciliation.md` records the publication-path defect. Frozen numeric fixture and D01-002 Gates A-J remain unchanged and UNSCORED.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**. The 1000-series critical path is complete. Highest-priority unblocked 2000-series work remains **D01 — coupled-control stability and tandem-joint authority**, state **EXPERIMENT / CLEAN EVIDENCE-RETENTION PREFLIGHT ATTEMPT 3 ACTIVE**.

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

### Clean evidence-retention lineage

Attempt 1 (`018`, workflow `34355802800`) failed before runtime because its Python rewrite deleted newly inserted provenance-producing git commands; `/tmp/d01-observer.patch` never existed. Pure harness defect.

Attempt 2 (`019`, workflow `34362010265`, job `102501097837`, artifact `10109273124`) completed with exit 0 and reproduced the validated fixture without retuning: Y commands/feedback settled at 10; low offset `0.020` gave duplicate ferror `-0.02 < 0.05`, no duplicate fault, Cartesian Y 10, motion enabled; high offset `0.200` gave principal ferror 0, duplicate ferror `-0.2`, duplicate fault true, Cartesian Y 10, motion disabled; fresh re-enable was attempted only after clear; 2,200 atomic rows; zero producer overruns; empty local collector stderr; phase/order predicates passed. The runner locally inventoried patch/SHA/INI/HAL/topology/thread/logs/samples/recorder health and printed an evidence-retention PASS.

However, independent inspection of the downloaded GitHub artifact proved the actual evidence directory was not published. `.github/workflows/lab-runner.yml` uploads only `lab-results/run-${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}` plus `LATEST.*`, while 018/019 wrote the package to `lab-results/d01-018-evidence/`. Artifact `10109273124` therefore contained only wrapper outputs and not the trace/config/patch files required by Gate J. `results/D01-004-clean-retention-attempt-2-reconciliation.md` classifies this as **RUNTIME + LOCAL RETENTION CHECK PASS / PUBLISHED ARTIFACT RETENTION FAIL**. Gates A-J remain UNSCORED.

Attempt 3 is `lab-jobs/020-d01-clean-retention-preflight-fix2.sh`, commit `2a838e587affe812940a4f473f408498221f5917`, workflow `34369209171`. It changes only publication placement by directing 019's evidence root beneath the workflow's already-uploaded `run-${id}-${attempt}` directory. Cwd, LinuxCNC source/fixture, offsets `0.020/0.200`, ferror limit `0.050`, NML command path, observer, phase ordering, sampler and frozen gates are unchanged. This is the third and final materially similar clean-retention attempt.

### Exact next-work checkpoint

1. Inspect only workflow `34369209171`; do not launch a duplicate while active.
2. If PASS, download artifact and verify the *files themselves* beneath the run directory: full `atomic.samples`, nonempty `observer.patch`, pinned `linuxcnc-commit.txt`, INI/HAL, topology/thread order, startup stdout/stderr, `recorder-health.txt`, empty/nonfatal collector stderr, and inventory. Re-run offline checks over the retained atomic stream for monotonic indices, phase-before-mutation witnesses, low hidden-divergence window, high duplicate-only trip, and <=3-sample motion-disable consequence.
3. Only after that artifact-level reconciliation passes may one separate independent authoritative D01 run be created using unchanged D01-002 P0-P8 and Gates A-J. Score gates from the retained authoritative artifact, not live assertions.
4. If attempt 3 fails materially similarly, stop the clean retention lineage under the three-attempt rule and redesign the retention mechanism before any further D01 lab run. Do not create a fourth incremental publication-path patch.
5. Keep F02 blocked until D01 has an accepted authority/fault-containment contract. Preserve sealed benchmark separation and delayed-retention obligation.

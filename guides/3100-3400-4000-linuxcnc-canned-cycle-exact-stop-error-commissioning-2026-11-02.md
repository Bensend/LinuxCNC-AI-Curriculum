# CYCLE-174 disconnected commissioning: G61.1/G64 and canned-cycle error unwind

**Audience:** 3100 mills, 3400 routers, 4000 interpreter/Task developers. **Review-only**; no connected machine. [Primary source audit](../research/4400_LINUXCNC_CYCLE_TERM_174_G611_G81_G82_CANONICAL_MODE_RESTORE_ERROR_SOURCE_AUDIT_2026-11-02.md).

## Prepare a reproducible oracle

Use **two separately built interpreters** at LinuxCNC stable `v2.9.10` (peeled `86cdca76fa2a36274c432caa21952b23c267989a`) and development `67437d8865e431a9a33f74cee912dbf891d3b4c5`. Record binary provenance, `rs274` version/commit, environment and exit status. No network machine, fieldbus, Mesa, actuators, physical drive or personnel exposure. The fixture files are **not safe machine programs**.

First run upstream `tests/interp/g6164/test.sh` and inspect its `expected` (mode oracle); then G81 G98/G99 upstream test sources for geometry. These establish a baseline, **not** the new CYCLE-174 error branch. Do not claim a test pass until command output is retained.

For each file in [`examples/4000_cycle_term_174`](../examples/4000_cycle_term_174/README.md), in a disposable interpreter environment:

```sh
rs274 -g a_g611_g81.ngc > a.stdout 2> a.stderr
printf 'exit=%s\n' "$?"
grep 'SET_MOTION_CONTROL_MODE\|STRAIGHT_TRAVERSE\|STRAIGHT_FEED' a.stdout
```

Repeat for B–F, saving separate stdout, stderr, exit code and binary revision. **Do not assume nonzero exit code or printed mode lines without inspecting actual output**. For D/E, preserve the complete error message and compare whether the standalone interpreter prints the intermediate EXACT command before failing. The normal successful cases must be checked before interpreting errors.

## Discriminating A–F matrix

| Case | Critical comparison | Source prediction |
|---|---|---|
| A G61.1 + valid G81 | STOP/EXACT/STOP ordering | exact-path internal override, exact-stop restored |
| B G64 P0.1 + valid G81 | BLEND/EXACT/BLEND ordering, P preserved | original continuous mode restored |
| C G61 + valid G81 | no redundant mode switch | exact-path remains |
| D G61.1 + invalid G82 missing P, Z5/R2 | error, no end-of-cycle restore in source | canonical mode changed before missing-P error |
| E same invalid G82, Z0/R2 | preliminary R traverse ordering | canonical traverse emitted before P validation; Task may discard |
| F G61.1 + valid G82 P0.1 | successful restoration control | STOP/EXACT/STOP |

**Second-layer Task test (separate):** Use an independently qualified physically disconnected `[self-hosted, openpressbrake]` runner with a reviewed SIM configuration. Capture Task interpreter error, queue clear, abort cleanup, `EMC_TRAJ_SET_TERM_COND` acceptance and commanded velocity for the exact same cases. A standalone canonical line is **not** evidence that Task issued a motion command. If qualified runner isolation is not verified, do not dispatch anything. No GitHub-hosted Actions.

**Acceptance / rejection:** Accept only source-to-canonical sequencing when `rs274` output agrees; accept Task/motion conclusions only with separate Task/TP telemetry and actual configuration. If a valid G82 fails unexpectedly, inspect modal feed, spindle, axes and test environment before attributing a regression. If D/E do not show EXACT, inspect interpreter error ordering and reset behavior; do not retrofit predictions.

## Engineering handoff

For a production CAM post, keep G61.1 and G64 explicit when their semantics matter; do not assume an internally expanded canned cycle inherits the current termination mode unchanged. Use fixture-aware clearance planning, not G61.1 as a safety stop. Review source correction in two parts: (1) prevalidate missing P/Q before any preliminary canonical traverse; (2) ensure cleanup/restoration for every post-switch return, including macro failures. Check all six plane handlers and existing G98/G99 behavior, and do not silently treat an RAII guard as command rollback.

**Adversarial transfer:** A G61.1 G83 program with no Q begins with Z below R. Identify (i) the earliest canonical motion candidate, (ii) the first error branch, (iii) the missing restore, and (iv) which of these proves physical motion. Correct answer requires source trace: preliminary R traverse may precede switch/error, missing Q returns early, restoration skipped, **none** proves physical movement without Task acceptance and machine evidence.

**Evidence:** fixtures and procedure prepared only; **NOT RUN**, no LinuxCNC build or machine. Independent safety and evaluator gates remain unchanged.

## Follow-through G: MDI abort and resynchronization (SOURCE-TRACED; NOT RUN)

The Task MDI error path clears the interpreter list, calls `emcTaskAbort`, queues a plan synchronization, and invokes `Interp::on_abort`. The inspected `reset→ON_RESET` drops buffered segments but does not reset `canon.motionMode`. `Interp::synch` reads `GET_EXTERNAL_MOTION_CONTROL_MODE` directly from that canonical object. Therefore an invalid G82 that changed canonical mode to EXACT can potentially make the post-error interpreter modal state report EXACT even though Task discarded the corresponding planner command. This is a **source-derived cross-layer mismatch hypothesis**, not a runtime verdict. See [174B source addendum](../research/4400_LINUXCNC_CYCLE_TERM_174_G611_G81_G82_CANONICAL_MODE_RESTORE_ERROR_SOURCE_AUDIT_2026-11-02.md#174b--abortresetsynch-follow-through-canonical-mode-can-be-reimported-after-the-failed-block).

On a **disconnected MDI Task** only, send G61.1; then invalid G82 without P; wait for abort/synch; inspect canonical, interpreter and motion TP modes separately; explicitly reassert G61.1 before a valid follow-up move as a control. Repeat for G64 P0.1 and both pinned revisions. Do not infer motion planner state from the G-code status alone. No Task simulator run occurred here.

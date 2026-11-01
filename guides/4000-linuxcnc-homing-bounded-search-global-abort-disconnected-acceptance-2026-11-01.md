# 4000 — Disconnected LinuxCNC homing differential acceptance: bounded moves, abort fanout, invalid joint

**Date:** 2026-11-01. **NON-GRADUATED.** Read [HOMING-90](../research/4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md), [HOMING-91](../research/4400_LINUXCNC_HOMING_91_CONFIGURED_JOINT_BOUNDARY_G282_SOURCE_AUDIT_2026-11-01.md), and prior [GCODE-28](../research/4400_LINUXCNC_GCODE_28_G282_HOME_CYCLE_TASK_MOTION_MODE_AND_RESULT_SOURCE_AUDIT_2026-10-31.md) before running. **ALL CASES NOT RUN.** Never use real hardware, networked Mesa/EtherCAT, physical drives, or a live press brake for these tests.

## Provenance and fixture

Compare LinuxCNC stable [v2.9.10 commit 86cdca76fa2a36274c432caa21952b23c267989a](https://github.com/LinuxCNC/linuxcnc/tree/86cdca76fa2a36274c432caa21952b23c267989a) and pinned [development 537cf2d765c96b6e75ae1db44e1dc0b9dba906a1](https://github.com/LinuxCNC/linuxcnc/tree/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1). Clone upstream [gantry_jjog.ini](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/gantry/gantry_jjog.ini) **into a disposable isolated workspace**. Four joints, X=0, Y1=1, Z=2, Y2=3, negative synchronized Y sequence -1; existing simulated HAL only. For the invalid-P tests use upstream development [invalid-pword/test.ini](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/tests/interp/g28.2/invalid-pword/test.ini) with three joints. Do not mutate upstream fixtures in place.

**Required preflight:** prove the runner has exactly labels `[self-hosted, openpressbrake]`, no hosted fallback, no attached machine I/O or privileged device passthrough, pinned checkout and reproducible dependencies. If not verified, **STOP before execution** and leave NOT RUN. This document is a test specification, not an Actions workflow dispatch.

## Acceptance matrix (12 cases)

| ID | Disconnected stimulus / comparison | Expected source-based discriminator; capture |
|---|---|---|
| H90-01 | Development, positive HOME_SEARCH_DIST, switch never closes | `HOME_INITIAL_SEARCH_WAIT` exhausts distance; error, HOME_ABORT; no `HOME_RETURN_*` on this path. Record command/feedback endpoint and all homed flags. |
| H90-02 | Development, positive HOME_LATCH_DIST, switch stuck during backoff | `home_return` schedules return to stored move_start, then abort. Record state trace and commanded vs feedback position separately. |
| H90-03 | Development, positive HOME_LATCH_DIST, switch fails on re-latch | Same return path; record failing stage and `HOME_RETURN_START/WAIT` transition. |
| H90-04 | Development, index-only and missing index pulse, bounded latch distance | Error and return path; `index-enable` cleared on abort. |
| H90-05 | Development synchronized Y1/Y2, Y1 latch distance exhausted while Y2 has moved | Both participating peers stop; peer with `moved` returns to its own start. Verify exact per-joint targets and no premature group completion. |
| H90-06 | Development, positive search distance missing switch on Y1 | Stops at search endpoint; **not** the synchronized latch-return behavior. Verify no return command for this path. |
| H90-07 | Stable, single X homing error after Y/Z homed | Stable HOME_ABORT clears only X's homed state. Preserve all-joint trace. |
| H90-08 | Development, same single X error after Y/Z homed | Development HOME_ABORT clears all configured joints' homed flags and disables all free planners. Record independent per-joint state. |
| H90-09 | Development, default/zero distances | `home_start_move` uses 2 × joint travel span as target; do not label it unlimited or safety-rated. Compare numeric command target. |
| H91-10 | Development upstream `invalid-pword/test-ui.py` with JOINTS=3 | G28.2 P3 rejected with joint-specific error, no 2s stall, mode preserved. Preserve stdout/stderr, operator errors and mode transitions. |
| H91-11 | Development P-1, P-2, P-3, P1.5 and missing P | P-1 is allowed, others rejected by interpreter; use existing upstream test oracle; **do not run G28.2 on stable**. |
| H91-12 | Stable vs development `linuxcnc.command().unhome(3)` with JOINTS=3; optional sanitizer-only motion unit boundary | Stable Task checks compile-time max, development configured count; capture serial, diagnostic, return, homed state. If testing raw motion `jno==all_joints`, isolate/sanitize, never drive machine. |

## Execution evidence contract

For each case retain exact source SHA, test fixture SHA/diff, INI/HAL, state trace with servo timestamps, command/NML serial, Task exec and motion modes, `joint.n.home-state/homing/homed/index-enable`, `free_tp` target/active or instrumented equivalent, joint feedback, exit status, stdout/stderr, and authoritative job runtime. Distinguish **requested return** from **observed return**, **Task accepted** from **realtime state**, and **test passed** from **physical machine verified**.

Do not count upstream test code as locally executed evidence. Report `NOT RUN` until actual retained output is inspected. If any case disagrees, classify HARNESS INVALID vs SOURCE HYPOTHESIS FAILED vs VERSION DRIFT; do not silently adjust the expected result. Keep safety-course evidence and independent evaluator gates untouched.

## Next decision

If runner remains unavailable, rotate to a distinct LinuxCNC internals question (e.g. realtime feed-hold, motion planner or real spindle/kinematics integration), rather than writing another homing test plan. If the matrix executes, use results to decide whether a narrowly scoped upstream issue/patch is justified; avoid duplicate PR #4172 work.

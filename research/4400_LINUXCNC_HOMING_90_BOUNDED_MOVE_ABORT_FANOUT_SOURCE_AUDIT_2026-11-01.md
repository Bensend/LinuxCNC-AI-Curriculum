# 4000-LC-HOMING-90 — Bounded search/latch moves and global abort fanout (LinuxCNC development vs 2.9.10)

**Date:** 2026-11-01. **Status:** NON-GRADUATED, SOURCE/DOC-CONFIRMED conditional, **NOT TESTED**. **Priority:** LinuxCNC motion/homing implementation and 3100 mill/router/gantry integration. Complements [HOMING-27](4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md) and [GCODE-28](4400_LINUXCNC_GCODE_28_G282_HOME_CYCLE_TASK_MOTION_MODE_AND_RESULT_SOURCE_AUDIT_2026-10-31.md), neither of which traces bounded-search return or global abort invalidation.

## Immutable source and documentary provenance

- LinuxCNC stable v2.9.10 commit [86cdca76fa2a36274c432caa21952b23c267989a](https://github.com/LinuxCNC/linuxcnc/tree/86cdca76fa2a36274c432caa21952b23c267989a): [homing.c](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/homing.c) around lines 170–207, 754–810, 1354–1361; [INI homing documentation](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-homing.adoc). This revision does **not** contain HOME_SEARCH_DIST or HOME_LATCH_DIST in the inspected implementation/docs.
- Development commit [537cf2d765c96b6e75ae1db44e1dc0b9dba906a1](https://github.com/LinuxCNC/linuxcnc/tree/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1): [homing.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/homing.c) lines 165–287, 864–943, 948–986, 1480–1529; [INI homing documentation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/ini-homing.adoc), sections HOME_SEARCH_DIST and HOME_LATCH_DIST.
- Real upstream **simulation** fixture: [gantry_jjog.ini](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/gantry/gantry_jjog.ini): four joints, duplicated Y (joints 1 and 3), `trivkins coordinates=XYZY kinstype=BOTH`, `HOME_SEQUENCE=-1` for both Y joints, and 0/2 for X/Z. It is **not** an installed machine acceptance result.

## Call-flow and state ownership

`[JOINT_n] HOME_SEARCH_DIST/HOME_LATCH_DIST` (INI/userspace) → joint homing parameters (Task/NML → realtime homing data) → `home_start_move(joint, vel, dist)` → joint free trajectory planner `free_tp.pos_cmd/max_vel/enable` → servo-cycle state `home_do_moving_checks` → (a) `HOME_ABORT` or (b) `home_return` → `HOME_RETURN_START/WAIT` → `HOME_ABORT`. The HAL `joint.n.home-sw-in` and `joint.n.index-enable` signals are observations/control handshakes, **not** independent travel or personnel-safety enforcement.

`home_start_move` records `move_start=joint->pos_cmd`, `move_dist=dist`, `move_vel=abs(vel)`. If `dist <= 0`, it instead commands **twice the joint configured travel span** (not unbounded travel). Positive/negative velocity selects direction; magnitude is clamped to `joint->vel_limit`. This is an ordinary trajectory target, not a safety-rated travel limit.

## Two importantly different failure outcomes

**Search stage (development):** `home_do_moving_checks` sees `free_tp.active == false` while `HOME_INITIAL_SEARCH_WAIT` and `move_dist > 0`. It reports that the switch was not found within HOME_SEARCH_DIST and enters `HOME_ABORT` **at the reached search endpoint**. The next attempt may continue from there. A zero/default distance instead uses the twice-travel-span target; physical limit behavior still depends on HAL and actual hardware.

**Backoff/latch/index stage (development):** If a positive HOME_LATCH_DIST is exhausted, `home_return(jno)` stops participating joints. The failing joint and any synchronized participating peers with `moved` true enter `HOME_RETURN_START`; each requests its own stored `move_start` at stored `move_vel`. Others enter `HOME_RETURN_WAIT`. `home_returns_done` waits until no participating return remains active, then enters `HOME_ABORT`. **Do not infer that physical return succeeded** from the commanded target or `free_tp.active` alone.

**Version-sensitive global abort fanout:** Stable `HOME_ABORT` clears only `H[joint_num].homing/homed/joint_in_sequence/index_enable` and disables only that joint's free planner. Development `HOME_ABORT` iterates `i=0..all_joints-1`, clearing **every joint's** `homing`, `homed`, `joint_in_sequence`, `index_enable`, setting every `home_state=HOME_IDLE`, and disabling every `free_tp`. Thus a single-joint homing failure can invalidate previously homed, unrelated joints in development; it is not merely a synchronized-gantry-group abort. Whether the broader invalidation is intended policy and how the UI surfaces it are **UNKNOWN**. The source establishes state mutation, not physical stopping distance.

## Practical implications / bounded engineering questions

For a 4-joint gantry (X=0, Y1=1, Z=2, Y2=3), deliberately distinguish (i) a missing Y1 switch during **search** (no automatic return), (ii) a failed Y1 **latch** (return commanded for participating synchronized peers), and (iii) a failed **single X** home after Y/Z were previously homed (development global homed invalidation versus stable local invalidation). Record `joint.0..3.homed`, `homing`, `home-state`, commanded/feedback positions, `index-enable`, aggregate `homing_active`, Task errors, and servo-cycle timing. Run only on a disconnected simulator with fault-injected HAL; do not use an actual gantry as a test harness.

## Claims ledger / falsifiers

| Claim | Evidence | Confidence | What would disprove / narrow it |
|---|---|---|---|
| Development positive search distance aborts at endpoint, not a return move | SOURCE-CONFIRMED `home_do_moving_checks` lines 248–258; DOC-CONFIRMED | High static | Instrumented free_tp trajectory differs under controlled switch-absent case |
| Positive latch distance initiates commanded return for participating group | SOURCE-CONFIRMED `home_return` and `HOME_RETURN_*`; DOC-CONFIRMED | High static | A reproducible path never reaches return states despite stated preconditions |
| Development abort clears every joint's homed flag; stable abort clears only current | SOURCE-CONFIRMED both `HOME_ABORT` cases | High static | Different compiled revision or other state repopulates flags before observation |
| Returned coordinate equals actual physical starting position | UNKNOWN; source only requests `move_start` | Not established | Encoder/following-error/drive trace required |
| Software homing is a personnel-safety mechanism | NOT CLAIMED | — | Independent personnel safety remains separate |

**Verification:** [12-case disconnected differential guide](../guides/4000-linuxcnc-homing-bounded-search-global-abort-disconnected-acceptance-2026-11-01.md). All cases NOT RUN. No builds, Python, simulation, hardware, evaluator, or Actions compute this session. No graduation or safety gate changes.

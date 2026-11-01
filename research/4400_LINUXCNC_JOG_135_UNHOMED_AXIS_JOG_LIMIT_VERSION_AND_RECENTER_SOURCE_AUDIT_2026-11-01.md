# JOG-135 — Unhomed jog window: joint/axis distinction, version delta and recentering
**2026-11-01 ~21:40Z UTC | 4000 LinuxCNC implementation / 3100 mills, 3400 routers, 3500 custom machines | NON-GRADUATED | SOURCE-CONFIRMED; runtime NOT RUN**

## Question and predecessor
When a controller has not established G53 machine origin, does an INI `MIN_LIMIT/MAX_LIMIT` bound *the total distance the operator can jog*, and is the behavior identical in joint and world-coordinate (teleop) modes? This is a **new versioned axis-jog implementation and moving-window investigation**, not a re-discovery of [HOMING-131](4400_LINUXCNC_HOMING_131_HOME_ALL_FAILURE_SEQUENCE_CONTINUATION_VERSION_AUDIT_2026-11-01.md), [RT-133](4400_LINUXCNC_RT_133_TRAJ_SERVO_CYCLE_ASSIGNMENT_CUBIC_REAL_CONFIG_SOURCE_AUDIT_2026-11-01.md), or historical FEED-JOG-01 (jog inhibition/normal-stop authority). PROGRESS was scanned for `unhomed jog`, `jog limits`, `recenter`, `joint jog` and nearby mechanisms; none had this source-level cross-version distinction.

## Pinned original source and evidence
- LinuxCNC **stable v2.9.10**: [`axis.c` blob `c5dbdf908c2b9b46e49601700bcee0a4d692721f`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/axis.c), [`command.c` blob `0b79061d39be915bbea548b2c33bb794d31ab302`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), [`motion.c` blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c).
- LinuxCNC **development pinned** `06864e23559e70463fc7112d5ce77138bcbc288c`: [`axis.c` blob `f6dd8d4aef0622c17f1f9dc9041ff5e3db7640e8`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/axis.c), [`command.c` blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/command.c).
- [Official stable homing documentation](https://linuxcnc.org/docs/2.9/html/config/ini-homing.html) says machine soft limits are referenced to a known home; unhomed motion does not provide that position trust. [Official kinematics documentation](https://linuxcnc.org/docs/2.8/html/man/man9/kins.9.html) distinguishes identity versus `KINEMATICS_BOTH` and duplicated axes.

## Trace A — free/joint jogging (both inspected versions)
`emcmotCommandHandler` in `command.c` dispatches `EMCMOT_JOG_CONT` / `EMCMOT_JOG_INCR` / `EMCMOT_JOG_ABS`. When **not TELEOP**, `joint_jog_ok` and `refresh_jog_limits` use:
- Homed: `min_jog_limit=min_pos_limit`, `max_jog_limit=max_pos_limit`.
- Unhomed: `range=max_pos_limit-min_pos_limit`; `min_jog_limit=joint->pos_fb-range`; `max_jog_limit=joint->pos_fb+range`.
- Continuous jog assigns `joint->free_tp.pos_cmd` to the appropriate limit; incremental jog rejects a target beyond those calculated bounds. This is **one command's current-feedback-relative window**, not a cumulative travel odometer. The code recomputes the window when a later jog command arrives.

**Source-derived arithmetic, NOT an executed test:** with INI [-100,+100] mm (range 200 mm) and unhomed joint feedback at +10 mm, positive continuous jog target is +210 mm. If the operator releases at +60 mm and issues another positive jog, the newly calculated target is +260 mm. This does **not** mean any actual machine will reach that target: the simple trajectory planner, enable state, feedback, limits, faults and physical travel still matter. It does mean the arithmetic does **not** impose a total 200 mm cumulative movement cap before homing.

## Trace B — teleop/axis jogging differs by version
**Stable v2.9.10 `axis.c` lines 262–318:** `axis_jog_cont` targets the literal `axis->max_pos_limit/min_pos_limit`; `axis_jog_incr` and `axis_jog_abs` compare against those fixed INI limits. `update_teleop_with_check` (lines 621–650) checks `teleop_tp.curr_pos + ext_offset_tp.curr_pos` against fixed axis soft limits on every update, even if the axis is not homed.

**Pinned development `axis.c` lines 279–321, 324–385, 712–745:** new `axis_is_homed(axis_num)` consults `identityKinematicsAxisJointsBitmap` and requires **every joint mapped to that axis** to be homed; missing map falls back to all-homed. New `axis_jog_limits` selects fixed INI limits if homed, or `teleop_tp.curr_pos ± (max_pos_limit-min_pos_limit)` if unhomed. Continuous/incremental/ABS axis jogging now uses that dynamic window. In `update_teleop_with_check`, an unhomed axis returns **before** the fixed INI axis-limit check. This is a concrete source version delta, not proof of a regression or unsafe physical outcome.

**Same arithmetic:** unhomed axis `teleop_tp.curr_pos=+10`, INI [-100,+100] => stable positive continuous jog target +100 mm; development target +210 mm. After stopping at +60, development next command target +260 mm. Once homed, both target +100 mm (subject to all other checks).

## Reachability and important exclusions
`motion.c::switch_to_teleop_mode` rejects TELEOP for non-identity kinematics until **all joints homed**; therefore the unhomed-axis teleop difference is most directly reachable with identity kinematics (or another implementation that reports identity), **not** as a general claim that a standard `kinstype=BOTH` gantry can jog unhomed in world mode. In free mode, the shared joint moving-window logic is present in both versions. The per-axis mapping in development matters for duplicated letters only after the mode preconditions are satisfied.

Neither source trace proves how a particular GUI chooses joint versus axis jog, whether external hard limits work, or physical travel. This is ordinary control, **not independent personnel-safety authority**. Do not use an unhomed jog window as a physical clearance or collision guarantee.

## Bounded verification oracle — NOT RUN
On a positively qualified **physically disconnected** `[self-hosted, openpressbrake]` environment only, use an identity-kinematics software simulation with an INI axis span [-100,+100] and unhomed axis starting at +10. Capture motion mode, homed flags, commanded and feedback positions, `EMCMOT_JOG_CONT` axis/joint selector, `teleop_tp.pos_cmd`, `free_tp.pos_cmd`, errors and actual execution times. A/B stable vs development, then repeat at +60 and after homing. Distinguish **target command** from **achieved position**; do not dispatch any machine-connected outputs. Record exact binary/source commit and job timestamps. If qualified compute unavailable, retain SOURCE-CONFIRMED and do not claim TEST-CONFIRMED.

## Open
Does a specific GUI permit an unhomed identity-kinematics TELEOP jog in the same manner on both versions? Are all axis/wheel-jog paths consistent with the new development dynamic window? What regression tests already cover this? These are distinct next questions, not established results.

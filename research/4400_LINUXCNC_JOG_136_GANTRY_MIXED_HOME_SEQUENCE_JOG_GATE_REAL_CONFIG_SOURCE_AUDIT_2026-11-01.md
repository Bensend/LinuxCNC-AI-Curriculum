# JOG-136 — Mixed-sign HOME_SEQUENCE, jog gating and the real gantry-panel HAL handoff
**2026-11-01 ~21:40Z UTC | 4000 LinuxCNC implementation / 3100–3500 gantry transfer | NON-GRADUATED | SOURCE/DOC-CONFIRMED, no runtime execution**

## Scope and novelty
This is a **source-depth and real-config integration** of documented gantry joint-jog restrictions, not a claim that LinuxCNC's negative `HOME_SEQUENCE` prohibition is newly discovered. It extends [HOMING-131](4400_LINUXCNC_HOMING_131_HOME_ALL_FAILURE_SEQUENCE_CONTINUATION_VERSION_AUDIT_2026-11-01.md) (post-failure Home All sequence) and [JOG-135](4400_LINUXCNC_JOG_135_UNHOMED_AXIS_JOG_LIMIT_VERSION_AND_RECENTER_SOURCE_AUDIT_2026-11-01.md) (moving unhomed jog windows). **Incremental question:** when one joint has a negative sequence and another has the *same absolute value but a positive sign*, which joints does the command handler actually refuse to jog?

## Exact upstream source
- Stable v2.9.10 [`homing.c` blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/homing.c) lines 212–225, 686–690; [`command.c` blob `0b79061d39be915bbea548b2c33bb794d31ab302`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) lines 469–491; [`motion.c` blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c) lines 163–177.
- Pinned development `06864e23559e70463fc7112d5ce77138bcbc288c`: [`homing.c` blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/homing.c) lines 295–309; [`command.c` blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/command.c) lines 509–531.
- [Stable official homing specification](https://linuxcnc.org/docs/2.9/html/config/ini-homing.html), §HOME_SEQUENCE / inhibiting homing, documents synchronized final moves, joint-mode jog prohibition and an example dynamic HAL override.
- Real upstream [`gantry_jjog.ini` stable blob `925e897831c1ef5c2df6b77a0aac1a14c6629dc0`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/gantry/gantry_jjog.ini), [stable `gantry_panel.hal` blob `cbc2d78412a35170e2f1d3d2a7a4124824129b49`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/gantry/gantry_panel.hal), [development `gantry_panel.hal` blob `178ddd5e615a0c1c3db008b7f1730f344457eb58`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/configs/sim/axis/gantry/gantry_panel.hal).

## Mechanism: flag applies to *every* member of a synchronized group
`homing.c::update_home_is_synchronized` clears all `H[jno].home_is_synchronized` flags, then for **each negative** `H[jno].home_sequence`, loops over **all joints** and sets the flag for any `jj` satisfying `abs(H[jj].home_sequence)==abs(H[jno].home_sequence)`. This includes a joint whose own sequence is **positive**.

`command.c::emcmotCommandHandler` checks the flag for all three `EMCMOT_JOG_CONT/INCR/ABS` operations when **not TELEOP** and homing is not active. It returns before jogging; the check does **not** require `get_homed(jno)==false`. Hence a post-home operator switch back to joint mode does not itself clear the restriction.

| Source-derived pair `HOME_SEQUENCE` | Computed `home_is_synchronized` flags | Individual free/joint jog (no active homing) |
|---|---|---|
| `-1,-1` | both true | both refused |
| `-1,+1` | both true | both refused, **including +1** |
| `+1,+1` | both false | not rejected by this specific check; other jog checks still apply |

This is a **source-derived flag oracle, NOT a tested UI/physical outcome**. It clarifies the manual's negative-sequence description; it does not contradict the documented synchronized final move.

## Real four-joint gantry example and HAL contract
`gantry_jjog.ini` uses `trivkins coordinates=XYZY kinstype=BOTH`, mapping X→joint0, Y→joint1 and joint3, Z→joint2; `HOME_SEQUENCE` is 0, -1, 2, -1 respectively. `KINEMATICS_BOTH` means TELEOP/world mode requires all joints homed, per `motion.c::switch_to_teleop_mode`. The duplicated Y axis is not an independent pair of G-code axes.

The **actual** `gantry_panel.hal` POSTGUI config:
1. Uses `mux2` to select `home_sequence=-1` (normal synchronized homing) versus `+1` (individual joint-jog commissioning), feeding `ini.1.home_sequence` and `ini.3.home_sequence`.
2. Drives `motion.homing-inhibit` from the same `pyvcp.jj_enable` switch to prevent an unsynchronized Home All while joint jogging is enabled.
3. Sends the **same** `pyvcp.jj_counts-i` to both `joint.1.jog-counts` and `joint.3.jog-counts`, and the same scale to both; this is a common *command* source, not proof that two physical motors remain square under feedback disturbances.
4. Requires `POSTGUI_HALFILE` because `ini.N.home_sequence` pins are available only after milltask starts.
5. **Version-specific HAL syntax:** stable loads `conv_float_s32 names=home_sequence_s32`; pinned development loads `conv_real_sint names=home_sequence_sint`. Do not blindly copy the converter name between revisions.

**Authority boundary:** the real config intentionally enables potentially racking individual joint jogs in a special commissioning state. This is not a personnel-safety function, and the example cannot certify gantry geometry, physical limits, actuator synchronization or independent stop authority. Keep the special commissioning state distinct from normal operation.

## Disconnected verification, NOT RUN
With the actual upstream gantry simulation on a positively qualified physically disconnected `[self-hosted, openpressbrake]` runner: record both `ini.1/3.home_sequence`, `motion.homing-inhibit`, homing flags, motion mode, joint/axis jog selectors, `joint.1/3.jog-counts`, command targets and independent joint feedback. Predeclare cases (-1,-1), (-1,+1), (+1,+1), then a fully homed world-mode Y jog. Restore normal (-1,-1) after each case; never command physical motors. Capture the precise LinuxCNC revision and actual runtime. No job was dispatched in this source-only session.

## Remaining question
Does the GUI explicitly surface the mixed-sign jog refusal and prevent mode confusion? That requires a GUI/NML path trace or executable evidence; the source table alone cannot establish it.

# 4000-LC-HOMING-91 — Configured-joint bounds, G28.2 Pn rejection, and the remaining realtime off-by-one boundary

**Date:** 2026-11-01. **NON-GRADUATED.** This is a **new boundary-specific continuation** of [GCODE-28](4400_LINUXCNC_GCODE_28_G282_HOME_CYCLE_TASK_MOTION_MODE_AND_RESULT_SOURCE_AUDIT_2026-10-31.md), not a repeat of its G28.2 canonical queue explanation. Stable v2.9.10 does **not** implement the inspected G28.2 command; compare only the generic joint-home/unhome APIs across versions.

## Pinned sources

- Stable [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskintf.cc#L767-L789) `emcJointHome` / `emcJointUnhome`: rejects `joint >= EMCMOT_MAX_JOINTS` (compile-time limit) but returns **0** for rejected values, and does not check the configured `TrajConfig.Joints`.
- Development [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskintf.cc#L762-L823): rejects `joint >= TrajConfig.Joints` and invalid negative values, emits an operator-visible message, returns `EMCMOT_COMM_ERROR_COMMAND`. `emcJointHome` accepts -1 (all); `emcJointUnhome` accepts -1/-2 as internal API sentinels.
- Both versions [homing.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/homing.c#L676-L711) `base_set_unhomed` use `if (jno > all_joints)`, not `>=`. **At exactly `jno == all_joints` this guard fails to reject**, and `joints[jno]` is subsequently referenced unless the extrajoint/motion-mode guard returns first. The arrays are sized for a compile-time maximum; out-of-config access is not automatically out-of-allocation. The public development Task path now blocks this input. A raw direct motion/NML bypass was **not executed**.
- Development [emctaskmain.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emctaskmain.cc#L1726-L1769) restores the prior trajectory mode immediately when a queued G28.2 home is rejected before starting; [WAITING_FOR_HOMING](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emctaskmain.cc#L2892-L3045) handles later starts/failures.
- Development upstream regression [tests/interp/g28.2/invalid-pword/test-ui.py](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/tests/interp/g28.2/invalid-pword/test-ui.py) explicitly tests a three-joint configuration's `G28.2 P3`, missing P, P-2, P-3, fractional P, diagnostic wording, elapsed time, `homed`, and mode preservation. **TEST-DEFINED, NOT RUN HERE**.
- Upstream [PR #4172](https://github.com/LinuxCNC/linuxcnc/pull/4172), merged **2026-09-17**, reports the field problem on a Mesa 7I95T gantry: G28.2 P5 on a five-joint machine gave a generic start timeout and left joint mode until later intervention. **COMMUNITY/MAINTAINER-REPORTED**, not independently reproduced.

## Execution and error boundary

`linuxcnc.command().unhome(joint)` or GUI/HALUI → `EMC_JOINT_UNHOME` NML → Task `emcJointUnhome` → motion `EMCMOT_JOINT_UNHOME` → realtime `base_set_unhomed`. In stable, a configured-count-exceeding but compile-time-valid joint number can be sent. In development, Task returns a nonzero command error with an operator diagnostic before motion sees it. An out-of-range return value of 0 in stable must **not** be interpreted as successful homing or unhoming.

For G-code specifically, development `G28.2 Pn` goes through interpreter validation, canonical queue flush and queued Task's FREE-mode dip; a rejected Pn must not linger for the 2-second homing start timeout or leave the previous motion mode changed. The upstream regression is an appropriate existing oracle. Stable has no corresponding G28.2 path.

## Residual lower-layer concern

The `jno > all_joints` check remains in **both** inspected realtime implementations. The development Task guard mitigates ordinary NML/API calls, but defense-in-depth should use `jno >= all_joints` in motion as well, with a test of exactly the first unconfigured index. Do **not** call this a demonstrated buffer overflow or a proven installed-machine vulnerability. At `jno == all_joints == EMCMOT_MAX_JOINTS`, it could be beyond the allocated joint array; at a smaller configured count, it is typically inside allocated storage but not an active joint. The extrajoint guard and current motion state can change the observed diagnostic.

## Independent test criteria

1. Verify configured 3-joint development simulation rejects P3 immediately and preserves mode and joint homed flags (upstream test already defines this).
2. Verify P-1 accepted, P-2/fraction/missing P rejected, with **no new G28.2 test asserted for stable**.
3. Compare generic `unhome(3)` on stable versus development with three configured joints; record Task return/operator errors, motion command serial, and joint state. A stable zero return alone is not a success oracle.
4. For motion lower-layer off-by-one, use only a **disconnected instrumented software harness** with bounds sanitization; do not inject malformed realtime commands into an actual machine.
5. Maintain independent safety authority; command acceptance and `homed` status are not physical position-trust certificates.

**Evidence:** SOURCE-CONFIRMED static, upstream regression TEST-DEFINED, maintainer report COMMUNITY-REPORTED, runtime TEST-CONFIRMED **none**. No test/build/runner/hardware execution this session.

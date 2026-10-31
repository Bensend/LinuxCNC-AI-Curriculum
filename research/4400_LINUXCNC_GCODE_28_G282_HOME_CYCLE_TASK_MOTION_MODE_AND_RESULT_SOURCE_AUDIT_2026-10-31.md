# 4000-LC-GCODE-28 — Development G28.2 homing: interpreter barrier, Task FREE-mode dip, result and version boundary

**Audit date:** 2026-10-31. **Status:** SOURCE-CONFIRMED pinned development path, v2.9.10 absence, UPSTREAM-TEST-DEFINED only; no execution. **NON-GRADUATED.** Companion to [HOMING-27](4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md).

## Engineering question

Can G-code trigger a complete homing cycle in program order, including a joint-mode transition, and how does Task decide that the cycle really ran and completed? This is a **version-specific** LinuxCNC implementation topic, not a generic G28/G30 machine-home move.

## Immutable provenance and version boundary

Pinned development [24e84c4506b41634240f7087f0295e361a954886](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), published 2026-10-30:

- [`src/emc/rs274ngc/interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc), blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`, `convert_home_cycle` ~3265–3299 and G28.2 dispatch ~4525.
- [`src/emc/task/emccanon.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emccanon.cc), blob `5ad736c59e85495aa06573ebcad2d49d59145583`, `HOME_CYCLE`/`HOME_CYCLE_JOINT` ~537–554.
- [`src/emc/task/emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emctaskmain.cc), blob `049c640f1af1b21c18161d6c065ff6f3e35fd83b`, queued-command handling ~1726–1769, preconditions ~1657, postconditions ~2632, `WAITING_FOR_HOMING` ~2892–3045.
- [`src/emc/task/taskintf.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/taskintf.cc), blob `2a429b0f66b2593cf669d6d25c5e54105390a696`, `emcJointHome` ~762–799. [`src/emc/motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`, `EMCMOT_JOINT_HOME` ~1498–1535. [`src/emc/motion/control.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, `homing_runs` increments on a rising `get_homing_is_active()` ~2285.
- Pinned stable [v2.9.10 interpreter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc) blob `f01a359652d588d59c9e210fa441a99d2ee19598`, [canonical](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc) blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`, and [Task](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc) blob `7292a172023a5b42b023447c2458cb766c93fc9b` **do not contain** the inspected G28.2 conversion, `HOME_CYCLE`, or `WAITING_FOR_HOMING` implementation. Do not use G28.2 as a v2.9.10 recipe.

## Source-level command trace

1. **Interpreter, userspace:** `G28.2 P-1` requests all joints; `P0`, `P1`, etc. request one joint. `convert_home_cycle` rejects missing P, fractional P, P less than -1, and active cutter compensation. It sets `home_flag` for an interpreter execution barrier and later position resynchronization; unlike G28/G30 this is a homing-cycle command, not just a stored-position traverse.
2. **Canonical queue, userspace:** `HOME_CYCLE` and `HOME_CYCLE_JOINT` call `flush_segments()` **before** appending `EMC_JOINT_HOME`, preventing buffered lookahead moves from being reordered after homing. Task preconditions drain prior motion.
3. **Task queued path:** `emcTaskIssueCommand` distinguishes queued interpreter commands from immediate GUI/HALUI requests via `issuingQueuedCommand`. Only queued commands save the previous trajectory mode, request FREE/joint mode, record the target, time and `homing_runs`, and enter `WAITING_FOR_HOMING`. Immediate GUI/HALUI `EMC_JOINT_HOME` remains a pass-through; it does **not** receive Task's automatic mode dip/restore.
4. **Motion command, realtime:** the command handler accepts FREE or a tightly guarded transition toward FREE with no motion queue, checks `motion.homing-inhibit`, existing homing and motion enable, and calls `do_home_joint`. A command may be rejected by motion while Task's NML send succeeds; NML acceptance is **not** homing proof.
5. **Task completion, userspace:** Task watches aggregate `homing_active` **or** any per-joint `homing`, so a gap between HOME_SEQUENCE groups does not appear to be completion. `homing_runs` detects a cycle that started and finished between Task polls. If no start is observed, Task waits up to **2.0 seconds** and errors. Once a run is observed and stops, Task requires the target joint(s) to be homed. It restores the prior mode only when successful and legal for the machine's kinematics; otherwise it reports an error and leaves the controller in FREE for operator intervention. It does not impose a general timeout on a cycle that started.

## Cross-layer consequence with HOMING-27

On a single already-homed absolute-encoder joint with no `HOME_SEQUENCE`, `G28.2 P-1` follows the **same** Home All `-1` motion path that first clears joint 0's `homed` flag but excludes it from the sequence. Task's `all_target_homed` check is therefore predicted to **fail** if the request is accepted and the sequence terminates. Conversely `G28.2 P0` takes the individual `HOME_NO_REHOME` path; it need not modify the coordinate. These are **SOURCE-CONFIRMED cross-layer conditional predictions**, not executed G-code results.

The 2-second start timeout is a **Task observation/rejection detector**, not a safe travel limit, a maximum homing duration, or a personnel-protection guarantee. `homing_runs` is a start-edge counter, not an encoder-index or final-position certificate.

## Reproducible discrimination without machine motion

In a verified isolated development RIP simulation only, compare `G28.2 P0` and `G28.2 P-1` against the copied upstream absolute-encoder fixture with/without `HOME_SEQUENCE=0`. Capture NML/operator errors, `homing_active`, `homing_runs`, `joint.0.homing`, `joint.0.homed`, `joint.0.pos-fb`, `joint.0.motor-offset`, Task mode before/after and command exit status. The [practical guide](../guides/4000-linuxcnc-home-all-absolute-encoder-and-g282-discriminators-2026-10-31.md) defines expected distinctions. **No test run, workflow dispatch, hardware motion, independent evaluator or blind score in this audit.**

**Unknowns / next:** runtime behavior under rapid homing status transitions, exact installed-version compatibility, and any upstream fix to the Home All joint-0 exception. If a source-only follow-up adds no information, rotate to trajectory planner or tool-change implementation instead of manufacturing more homing notes.

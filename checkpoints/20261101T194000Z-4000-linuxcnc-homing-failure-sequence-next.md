# 2026-11-01 ~19:40Z — 4000-LC-HOMING-131 continuation checkpoint

**LinuxCNC-first. NON-GRADUATED.** 3100 mill/router/gantry and 3500 multi-joint transfer. Current branch: `main`.

## Durable source result

- [HOMING-131](../research/4400_LINUXCNC_HOMING_131_HOME_ALL_FAILURE_SEQUENCE_CONTINUATION_VERSION_AUDIT_2026-11-01.md) traces stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` vs development `06864e23559e70463fc7112d5ce77138bcbc288c`: `HOME_SEQUENCE_WAIT_JOINTS` advances on IDLE, not HOMED. Stable `HOME_IS_SHARED` already-active branch logs error and sets IDLE directly, allowing later Home All groups to start; stable HOME_ABORT only removes the failed joint. Development routes the same shared-switch error to global HOME_ABORT, clearing every joint's `joint_in_sequence` and preventing later groups from starting in that same Home All. These are SOURCE-CONFIRMED state paths, **not** observed motion.
- [Practical disconnected A/B guide](../guides/3100-3500-4000-linuxcnc-home-all-failure-sequencing-disconnected-preflight-2026-11-01.md) freezes real upstream `configs/sim/axis/gantry/gantry.ini`: X0 sequence 0, paired Y1/Y2 -1, Z2 sequence 2; inject X `HOME_IS_SHARED=1` and asserted simulated switch before accepted Home All. Stable predicts later Y start; development predicts no later Y start. All five cases **NOT RUN**.
- Explicit predecessor comparison: [HOMING-90](../research/4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md) already covered global abort/bounded moves; [HOMING-27](../research/4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md) covered joint0/unsequenced behavior. This work adds the **post-failure coordinator progression and shared-switch version divergence** only.
- No build, simulator, HAL execution, physical machine operation, independent evaluator or Actions dispatch. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged; no new authoritative runtime. Closed 1000/2000/F02/3000 levels remain CLOSED, independent personnel safety and OpenPressBrake G0/G1 HOLD unchanged.

## Next highest-value unblocked actions

1. **Only if** `[self-hosted, openpressbrake]` access and physical disconnection have been independently qualified: run bounded HOMING-131 A/B in copied upstream gantry simulator on pinned stable and development. Preserve exact INI/HAL diff, switch precondition, Task acceptance, servo-synchronous joint state, Y start/no-start, error text, binary SHA, exit and authoritative job runtime. Do not dispatch hosted workflows or treat runner label as physical isolation proof.
2. If runner still unqualified, rotate to **a distinct LinuxCNC motion/HAL/INI implementation** (suggest: HostMot2 encoder index timing or coordinated spindle/tool changer handshake) with direct historical PROGRESS/research predecessor scan first. Avoid re-teaching HOMING-90 or accumulating unexecuted homing cases.
3. Preserve prior ARC-129/130, G10-128, ABSENC-126/127, TAP-124/125 and other runtime oracles as NOT RUN. Do not promote or reopen graduated levels based on static inspection.
4. Follow START_HERE, governance, evidence and current repository file-readiness rules. Keep existing hourly curriculum automation enabled.

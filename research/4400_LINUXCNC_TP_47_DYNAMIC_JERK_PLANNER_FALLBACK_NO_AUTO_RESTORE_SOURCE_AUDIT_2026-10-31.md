# 4000-LC-TP-47 — Dynamic jerk fallback does not automatically restore the selected planner

**2026-10-31 | LinuxCNC development-only planner implementation | NON-GRADUATED | SOURCE-CONFIRMED conditional.** Distinct from [TP-31](4400_LINUXCNC_TP_31_DEVELOPMENT_G64_R_PLANNER_SWITCH_DEFER_AND_REJECTION_SOURCE_AUDIT_2026-10-31.md): this investigates **live `ini.traj_max_jerk` and `ini.traj_planner_type`** interactions, not G64 R interpreter intent.

## Pinned evidence
- Development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` [`src/emc/ini/inihal.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/ini/inihal.cc), blob `e6a7d2ab1756bd9e81fd3ce894fb76a0ad23b046`, ~296–340.
- [`src/emc/ini/initraj.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/ini/initraj.cc), blob `36537e70bdc465824a9278a938d81d1d5adf09ab`, ~140–185: startup initializes max/current jerk and requested planner, falling back when jerk <1.
- [`src/emc/task/taskintf.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskintf.cc), blob `2a429b0f66b2593cf669d6d25c5e54105390a696`, ~1170: `emcTrajPlannerType` sends `EMCMOT_SET_PLANNER_TYPE`.
- [`src/emc/motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`, ~96–119 and ~1242–1292: planner request rejected for insufficient current jerk, otherwise applied when idle or deferred until queue idle.
- Stable v2.9.10 [`inihal.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/ini/inihal.cc), blob `01ddc240e19b587e6aac3dfd0b6971226de7263c`, does **not** have the inspected `traj_planner_type`/jerk live-pin branch. Do not transfer this behavior to stable.

## Exact state transition
Initial conditions in a development simulation: `ini.traj_max_jerk=2`, `ini.traj_planner_type=1`, motion idle, effective planner type 1.

| Step | HAL inputs | Source-issued command(s) | Shadow `old.traj_planner_type` | Expected effective type after idle |
|---|---|---|---|---|
| A startup | jerk=2, type=1 | `SET_MAX_JERK 2`, `SET_JERK 2`, `SET_PLANNER_TYPE 1` | 1 | 1 |
| B lower jerk | jerk=0.5, type=1 | `SET_MAX_JERK 0.5`, `SET_JERK 0.5`, `SET_PLANNER_TYPE 0` fallback | **1 (unchanged)** | 0 |
| C restore jerk | jerk=2, type=1 | `SET_MAX_JERK 2`, `SET_JERK 2`; **no planner-type command** | **1** | **0, absent another request** |
| D force a type transition | jerk=2, type=0 then 1 | planner-type 0 then 1 (subject to queue-idle defer) | 0 then 1 | 1 once applied |

The cause is two independent `CHANGED` branches. The jerk branch requests fallback type 0 when jerk drops below 1 but does **not** change `old_inihal_data.traj_planner_type`. Raising jerk back above 1 does not itself request type 1, and the unchanged type pin does not trigger the type branch. Thus **the requested HAL type can disagree with the active motion planner even after the jerk has recovered**. This is a source-derived prediction, not a measured test result.

## Additional conditional failure paths
- When a user changes `ini.traj_planner_type` to 1 while jerk<1, `inihal` updates the shadow to 1 but clamps the dispatched planner request to 0. Raising jerk later does not retry type 1 without another type-pin transition.
- `EMCMOT_SET_PLANNER_TYPE` refuses type 1 when the **current** motion jerk is below 1; `inihal` has already advanced the requested-value shadow before dispatch. A rejected or deferred request cannot be equated with active planner state.
- During queued motion, even a valid explicit type change can be deferred until queue idle. A returned Task/NML acknowledgement or HAL pin readback is not a definitive active-planner oracle.
- G64 R can separately request planner changes in development; the table explicitly assumes **no intervening G64 R or other planner requests**.

## Review-only improvement and test oracle
Prefer a single reconciler of `desired planner`, `valid jerk`, `pending switch`, and **actual active planner**. On recovery above threshold, reissue the desired type when needed; do not simply rely on the requested HAL pin's delta. A robust implementation should report invalid/rejected changes and not silently mark them applied. For a disconnected test, record the two HAL inputs, motion command trace (`motion-logger` or equivalent approved harness), queue-idle state, and **actual planner type** from motion status or a verified diagnostic; do not invent a `motion.planner-type` HAL pin without confirming it exists.

**Evidence:** SOURCE-CONFIRMED state-machine reasoning, DOC context, TEST-CONFIRMED none. No builds, simulations, Actions or machine operations. The prior [TP-31](4400_LINUXCNC_TP_31_DEVELOPMENT_G64_R_PLANNER_SWITCH_DEFER_AND_REJECTION_SOURCE_AUDIT_2026-10-31.md) remains valid; this audit adds the live-HAL recovery gap. [Acceptance guide](../guides/4000-linuxcnc-inihal-live-limit-and-planner-acceptance-2026-10-31.md).

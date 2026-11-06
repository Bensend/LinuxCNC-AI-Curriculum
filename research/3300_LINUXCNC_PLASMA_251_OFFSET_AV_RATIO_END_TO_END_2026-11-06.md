# PLASMA-251 — OFFSET_AV_RATIO end-to-end configuration trace (2026-11-06)

**Status:** LinuxCNC v2.9.10 SOURCE-CONFIRMED; 3300 NON-GRADUATED. No execution, simulator, hardware or lab compute. Continues [PLASMA-250](3300_LINUXCNC_PLASMA_250_EXTERNAL_OFFSET_MOTION_SOURCE_2026-11-06.md).

## Immutable upstream evidence

All paths in `LinuxCNC/linuxcnc` at tag `v2.9.10`; immutable Git blob SHAs obtained by fetching files at that tag:

| Source | Blob SHA | Relevant lines |
|---|---|---|
| [iniaxis.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/ini/iniaxis.cc) | `c664b73e104729e52f2d4bebc81176a5c5871972` | 34-37, 104-143 |
| [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc) | `96a041d1feef8560f37159a2f18b109171f084c3` | 473-523 |
| [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) | `0b79061d39be915bbea548b2c33bb794d31ab302` | 1854-1878 |
| [axis.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/axis.c) | `c5dbdf908c2b9b46e49601700bcee0a4d692721f` | 193-201, 473-477 |
| [external-offsets.adoc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/motion/external-offsets.adoc) | `9d943f613e1bdd511ecf093d76e6a4eb08ff6f89` | 24-43, 110-188 |

## Mechanism: a split of a single axis budget, not an added independent budget

1. `loadAxis` reads `[AXIS_L]OFFSET_AV_RATIO` into a per-axis array. Default is **0**. Values below 0 or above 0.9 are rejected with an error and **replaced with 0.1**, not clamped to the nearest endpoint. A valid 0 disables external-offset motion through zero maximum velocity and acceleration.
2. The loader calls `emcAxisSetMaxVelocity(axis, (1-r)*V, r*V)` and `emcAxisSetMaxAcceleration(axis, (1-r)*A, r*A)`. It separately retains the unpartitioned V/A in `old_inihal_data`; do not mistake that stored value for the planner's allocated limit.
3. `taskintf.cc` puts the planning limit and external-offset limit into distinct fields of `EMCMOT_SET_AXIS_VEL_LIMIT` and `EMCMOT_SET_AXIS_ACC_LIMIT`. It clamps a negative **planning** value to zero, but does not separately clamp the external value there; upstream ratio validation is therefore consequential.
4. `command.c` routes both fields to `axis_set_vel_limit` / `axis_set_ext_offset_vel_limit` and `axis_set_acc_limit` / `axis_set_ext_offset_acc_limit`. `axis.c` stores these ceilings and assigns them to the offset `simple_tp` on each offset-planning invocation.
5. This budget split is intended to preserve an axis-level speed/acceleration envelope under combined planned and offset motion. It is **not** a hardware-independent safety guarantee, and axis soft limits remain separately enforced (PLASMA-250). No measured combined velocity trace was obtained.

## Numerical fixture: QtPlasmaC metric simulator Z

Given `[AXIS_Z] MAX_VELOCITY=120`, `MAX_ACCELERATION=1200`, `OFFSET_AV_RATIO=0.5` (source configuration values previously pinned in PLASMA-249):

| Limit | Conventional planning | External offset |
|---|---:|---:|
| Velocity (mm/s) | 60 | 60 |
| Acceleration (mm/s²) | 600 | 600 |

`[JOINT_3] MAX_VELOCITY=60` and `MAX_ACCELERATION=600` are separate joint constraints. Their numerical match to the split conventional Z budget **does not establish** that joint motion can simultaneously deliver 60 mm/s planned plus 60 mm/s external offset; the joint envelope and following-error behavior must be checked in simulation. Do not add axis and joint limits together.

**Negative cases:** r omitted => 0/120 external/conventional velocity and 0/1200 external/conventional acceleration. r=0.9 => 108 mm/s external, 12 mm/s planned; 1080 mm/s² external, 120 mm/s² planned. r=1 or r=-0.01 => warning and replacement r=0.1, yielding 12 mm/s external and 108 mm/s planned; 120 mm/s² external and 1080 mm/s² planned. This is a replacement, **not** an error abort or saturation to 0.9/0.

## Reproducible inspection and diagnostic exercise

```sh
git -C linuxcnc rev-parse v2.9.10:src/emc/ini/iniaxis.cc
git -C linuxcnc show v2.9.10:src/emc/ini/iniaxis.cc | sed -n '99,145p'
git -C linuxcnc show v2.9.10:src/emc/task/taskintf.cc | sed -n '473,523p'
git -C linuxcnc show v2.9.10:src/emc/motion/command.c | sed -n '1854,1879p'
git -C linuxcnc show v2.9.10:src/emc/motion/axis.c | sed -n '190,202p;470,479p'
```

For a future isolated QtPlasmaC simulation, first record loaded INI values, then sample offset request, applied offset, motion command, servo period, offset-limited flag and Z following error. Compare r=0, 0.5 and 0.9 with identical bounded count requests, starting at Z center. Predeclare that r=0 should produce no offset displacement, and increasing r should raise the offset planner's theoretical speed/acceleration ceilings while lowering the conventional axis budget. A runtime result differing from these predictions should trigger INI/command/servo-thread inspection, not immediate defect classification. **Do not run on a physical torch or machine.**

## Evidence classification and handoff

- **SOURCE-CONFIRMED:** default, validation/replacement, split equations, Task command forwarding, realtime setter fields, planner ceiling assignment.
- **DOC-CONFIRMED:** official external-offset guide agrees with 0..0.9, default 0 and allocation.
- **ANALYTICAL ONLY:** numerical Z calculations and negative-case expected outcomes.
- **OPEN:** executable confirmation of ratio effects, exact cycle latency, combined joint/axis saturation, real Mesa plasma ADC/HAL and electrical timing.
- **NEXT:** rotate to source-grounded plasma DXF/CAM output interface or a real Mesa QtPlasmaC machine configuration; avoid extending the now-closed parser trace without a new falsifiable question. Preserve independent safety authority and all graduation/blind gates.

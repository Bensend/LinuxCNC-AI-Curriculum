# 4000 practical guide — serial robot IK and Puma560 kinematics/limit acceptance

**2026-10-31 | LinuxCNC v2.9.10 versus pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` | DISCONNECTED / NOT RUN.** Read [KINS-42](../research/4400_LINUXCNC_KINS_42_GENSER_JACOBIAN_SEED_CONVERGENCE_SINGULARITY_SOURCE_AUDIT_2026-10-31.md) and [KINS-43](../research/4400_LINUXCNC_KINS_43_PUMA560_M128_LIMIT_AND_DEVELOPMENT_PANEL_ROUTE_SOURCE_AUDIT_2026-10-31.md) before applying this guide.

## 1. Establish the machine and solver contract
Record the LinuxCNC Git commit/tag, `[KINS]KINEMATICS`, `[KINS]JOINTS`, `[TRAJ]COORDINATES`, all `[JOINT_N]` and `[AXIS_L]` limits, `puma560_dh.hal` A/ALPHA/D values, `[TRAJ]LINEAR_UNITS`, and initial homed joint vector. The Puma560 simulation uses `genserkins` (iterative Jacobian solver), **not** `pumakins` (separate analytic implementation). The supplied INI is inch-based and has `HOME=0.1` for joint 4.

## 2. Read-only pin and state inspection
After loading the disconnected simulation, use the appropriate HAL inspection commands, for example:
```sh
halcmd show pin 'genserkins.*'
halcmd show pin 'motion.*kins*'
halcmd show pin 'ini.*max_velocity'
halcmd show sig
```
Record `genserkins.last-iterations`, `genserkins.max-iterations`, `motion.kins-type`, `kinstype.is-0/1/2`, `motion.analog-out-03`, and the `ini.L.max_velocity` pins that actually exist. Confirm a signal path exists before assuming M68 changes kinematics. A value printed by an M-code is not proof of a consumed command.

## 3. Freeze the software-only scenarios before running
| ID | Variant | Controlled stimulus | Predicted discriminating evidence |
|---|---|---|---|
| R1 | stable Puma560 | type 0→1 via M129, then 1→0 via M128 | Existing HAL net can propagate M68 to motion; actual `motion.kins-type` must be recorded, not inferred from Tcl text |
| R2 | development Puma560 | same visible GUI-button M129/M128 route | Without a replacement net, M68 output-03 changes but kins-type need not follow; compare direct M429/M428 |
| R3 | both, **simulation-only edited INI** | robot axis X MAX_VELOCITY differs from joint 0 MAX_VELOCITY; M129→M128 | Check whether M128 restores `ini.x.max_velocity`; inspect Tcl `catch` failure |
| R4 | both | forward of a known joint vector then inverse of that pose, same seed | Report solver return, iterations, and independently calculated XYZ/rotation reprojection residual |
| R5 | both | same pose, different initial joint seed | Check branch/iteration dependence; never assume global optimum or unique inverse |
| R6 | both | near wrist singularity and unreachable target | Capture singular or nonconvergence error; no physical motion, no automatic restart |
| R7 | development | select via G12.1 Pn then inspect `#<_kins_type>`, `motion.kins-type` and Task error | Compare interpreter intent with actual active type **after synchronization** |
| R8 | both | inspect offsets and limit pins before/after switch | Changing kinematics does not validate G92/tool/external offset compatibility |

**Oracle:** a successful kinematics test requires correct active type, no relevant Task/motion error, stable joint state across the switch, valid joint limits, and a bounded independent forward-reprojection residual for inverse solutions. A successful MDI return, M66, low `last-iterations`, or pretty Vismach display alone is insufficient.

### Cross-machine discriminator R9 — mill/turn coordinate remap
Read [MILLTURN-44](../research/4400_LINUXCNC_MILLTURN_44_JOINT_AXIS_REMAP_LIMITS_OFFSETS_AND_KINS_SWITCH_SOURCE_AUDIT_2026-10-31.md) and inspect the upstream development `millturn.ini` and `millturn.comp`. With **fixed** joint feedback (100,20,-30,10), the calculated mill machine pose is (100,20,-30,10), while turn machine pose is (-30,-20,100,10). Compare actual kinematics type, joint feedback, raw machine pose, `ini.x/z.min_limit/max_limit`, selected G59.1/G59.2, and Task errors after M428/M429. Work-coordinate display includes fixture offsets and is not the raw-pose oracle. **NOT RUN**; do not enable hardware.

## 4. Evidence retention
Preserve exact INI/HAL/NGC/Tcl snapshots, LinuxCNC revision, command sequence, status and error channel, HAL pin and signal dumps, joint/Cartesian poses, solver iterations, expected-versus-observed table, and actual run timestamps. Distinguish **SOURCE-CONFIRMED** predictions from **TEST-CONFIRMED** observations; do not mark a scenario passed without its output. Use only a positively isolated `[self-hosted, openpressbrake]` runner for any later qualified compute. No hosted Actions runner, no hardware enable, no real robot.

## 5. Review-only implementation sketch
In M128, replace the typo `ini.$l.min_velocity` with `ini.$l.max_velocity` and make failed required writes visible. For development, refactor the button path so limits update and G12.1 selection are a single ordered, verified workflow; **do not** merely add an M66 after M68 and assume interpreter-aware switching. Use the existing upstream `tests/kins-switch-unsolved` and `tests/kins-switchkins-core` as examples of actual-type and position assertions, but those tests do not establish Puma560 panel or numerical residual behavior.

**Cross-cutting constraint:** LinuxCNC's IK and axis limits are not independent personnel-safety functions. Retain separate collision, travel, and personnel-safety authority. Graduated levels and existing independent evaluation gates are untouched.

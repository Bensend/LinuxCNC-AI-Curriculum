# 4000-LC-KINS-43 — Puma560 switch/limit helper drift: stale M68 route and masked MAX_VELOCITY restoration

**2026-10-31 | 4000 LinuxCNC implementation / 3500 robotics | NON-GRADUATED | source-only.**

## Increment beyond KINS-09/10
[KINS-09](4400_LINUXCNC_KINS_09_G121_G131_INTERP_TASK_MOTION_SYNCHRONIZATION_SOURCE_AUDIT_2026-10-30.md) and [KINS-10](4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md) already established interpreter-aware G12.1/G13.1 and failure acknowledgement. This audit checks a **different contract**: whether the *real upstream Puma560 panel's* M128/M129/M130 limit-adjustment scripts still select kinematics after the development INI/remap migration, and whether M128 restores the velocity limit it claims to restore.

## Immutable evidence
| Source | Stable v2.9.10 blob | Development commit \`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1\` blob |
|---|---|---|
| [Puma560 INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/puma560.ini) | \`c2bfc1c2a122f55b24bf3897e41e54e16dc44179\` | [\`046f5d118d58d8fc3a026c0b105759e5dbb393cd\`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/puma/puma560.ini) |
| [M128 Tcl](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/mcodes/M128) | \`9f2f6d53696f227935c2925ccecbc957c808b952\` | [\`263751003676ab5a48552517b1666cf5a7facfb5\`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/puma/mcodes/M128) |
| [M129 Tcl](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/mcodes/M129) | \`023bd2b0a8ead17599007373a0ed925511ca6efd\` | [\`f9f9a2d6b84f6aab21ef8e135272158e0ca13635\`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/puma/mcodes/M129) |
| [M428 remap](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/remap_subs/428remap.ngc) | \`36f8ee3e499aebef6bf1208313b8053e41f43937\` | [\`d2d0f3c8d39aabdfa4a855d1a7ff9400124d3909\`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/puma/remap_subs/428remap.ngc) |
| [Post-GUI HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/puma560_postgui.hal) | \`e73c14add088ee994514c8d1e9d48a8b46a39f9f\` | same blob |
| [INI-HAL pin creation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/ini/inihal.cc) | not separately pinned here | \`e6a7d2ab1756bd9e81fd3ce894fb76a0ad23b046\` |
| [basic_sim.tcl](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/hallib/basic_sim.tcl) and [sim_lib.tcl](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/hallib/sim_lib.tcl) | not separately compared | \`22bcebbf1ea2fc6662390066f517015cba8d4fe1\`, \`7d98add3051e612dd530a121ee004793f1b7428f\` |

## Finding A — limit restoration names a non-existent pin
Both inspected Puma M128 scripts use:
\`\`\`tcl
catch {hal setp ini.$l.min_velocity [set ::AXIS_[set L](MAX_VELOCITY)]}
\`\`\`
But the INI-HAL component creates \`axis_max_velocity[idx]\` (HAL \`ini.x.max_velocity\`, etc.), **not** \`axis_min_velocity\`. Official [switchkins documentation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/motion/switchkins.adoc) lists \`ini.L.max_velocity\`. The Tcl \`catch\` discards the failing command's error, and M128 can still print that limits were updated. **SOURCE-CONFIRMED** mismatch and suppressed error. Stock Puma560's six axis and joint MAX_VELOCITY values are all 30, so this particular INI does not establish a numeric velocity-limit discrepancy in the normal identity→robot sequence. **INFERENCE:** on a machine with different robot-axis versus joint-equivalent maxima, an M129→M128 round-trip could retain the identity limit after switching back. Do not claim measured over-speed.

## Finding B — development UI keeps an obsolete HAL selection route
Stable Puma560 \`[HAL]\` connects \`motion.analog-out-03\` to \`motion.switchkins-type\`; M128/M129/M130 Tcl invoke \`emc_mdi m68 e3 qN\` then \`m66 e0l0\`. Stable M428/M429/M430 remaps do the same. In the inspected **development** Puma560 INI, that \`net\` line is **gone**, and M428/M429 remaps now use interpreter-aware \`G12.1 P0/P1\`. Yet M128 and M129 still send \`M68 E3 QN\` and \`M66\` in MDI mode; M130 follows the same legacy pattern. The unchanged post-GUI HAL binds the visible type buttons to \`halui.mdi-command-03/04/05\`, which the INI maps to **M128/M129/M130**, not the updated M428/M429/M430. The inspected shared \`basic_sim.tcl\`/\`sim_lib.tcl\` does not create the missing kinematics-select net.

**SOURCE-CONFIRMED:** the inspected development config has an M68 output with no identified consumer for kinematics selection, while its panel still requests the old M-codes. **CONDITIONAL INFERENCE:** panel presses may update limits and report success without selecting the requested kinematics; a user-supplied extra HAL net or different installed config could change this outcome. The source alone does not establish what the GUI displayed or whether a user clicked the button.

## Distinct trust boundaries
1. A Tcl script's \`puts ... switched\` text is not a measured active-type acknowledgement.
2. \`M66 E0 L0\` forces an interpreter synchronization but cannot replace a missing HAL connection or make M68 an interpreter-aware G12.1 selection.
3. The development [G12.1/G13.1 documentation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/motion/switchkins.adoc) deprecates the direct HAL selection path precisely because interpreter lookahead/limits may not match the kinematics that motion runs.
4. \`ini.x.max_velocity\` must be verified by reading back the pin **and** the active-type status; changing a limit does not prove a kinematics switch, and a switch does not prove the limit changed.

## Minimal proposed correction (REVIEW-ONLY, NOT APPLIED)
- Change the M128 Tcl target from \`ini.$l.min_velocity\` to \`ini.$l.max_velocity\`; stop silently discarding HAL write errors, or at least report and fail the operation when a required pin is absent.
- On development, make the panel's selection path perform **limits update → interpreter-aware G12.1 Pn → post-sync verification**, with an explicit supported MDI/subroutine sequence and error handling. Avoid keeping a parallel M68 selection path solely for panel buttons. Preserve the distinction between type 0 robot and type 1 identity; do not assume G13.1 always means numeric type 0.
- Verify actual active type via \`motion.kins-type\`, \`kinstype.is-N\`, Task status/error, and joint/Cartesian pose before allowing any follow-on motion. Coordinate offsets and external offsets need separate review.

## Acceptance matrix, disconnected simulation only
A. On pinned stable INI, confirm M129 and M128 select 1 and 0 respectively, with the legacy net present. B. On pinned development INI, compare panel M129 with direct M429/G12.1 and capture actual type, output-03, and error messages. C. Change a **simulation-only** axis MAX_VELOCITY to differ from its joint counterpart; switch identity→robot and compare \`ini.x.max_velocity\` before/after M128. D. Capture Tcl \`catch\` return/error rather than relying on printed text. E. Verify a second independent axis and offset before concluding the limit restoration is complete. F. Repeat without any physical actuators or personnel-exposed equipment. **NONE EXECUTED.**

## Evidence status and next
SOURCE-CONFIRMED selected files; DOC-CONFIRMED G12.1 recommendation; INFERENCE for installed GUI/runtime outcomes; TEST-CONFIRMED none. No build, runner, LinuxCNC simulation, machine operation, or independent evaluator. The useful next verification is the panel-versus-remap A/B comparison, not a third general discussion of switch status already in KINS-10.

# 4400-SPINDLE-ZERO-01 — Zero RPM is not drive OFF
**Open-book technician safety review | 2026-10-29 | NON-GRADUATED | paper-only**

Read the [exact v2.9.10 source audit](../research/4400_SPINDLE_ZERO_01_LINUXCNC_2910_M3_S0_ON_BRAKE_RELEASE_AND_LATER_SPEED_REARM_SOURCE_AUDIT_2026-10-29.md), then compare [existing M70/M72/M73 modal restore](../research/4400_MODAL_RESTORE_01_LINUXCNC_2910_M70_M72_M73_SPINDLE_RESTART_AND_COOLANT_RESTORE_SOURCE_AUDIT_2026-10-28.md) and [G95 speed-feedback mismatch](../research/4400_G95_SPEED_01_LINUXCNC_2910_SPINDLE_SELECTION_RPS_FEEDBACK_AND_FALSE_FEED_SOURCE_AUDIT_2026-10-29.md).

## Technician question
The HMI displays **0 RPM** immediately after `S0 M3`. Is the drive disabled, the mechanical brake engaged, and the spindle safe to approach?

**No.** Pinned stock LinuxCNC sets ordinary spindle ON state independently from speed; `spindle.N.on` can be HIGH at zero commanded RPM and the motion layer requests brake release. Later increasing S or override can request rotation without a fresh M3. **Physical behavior is unknown until the selected drive, HAL and safety system are examined.** Neither zero RPM nor normal M5 proves independent STO, safe standstill or energy isolation.

## Three unscored desk challenges
1. Trace `S0 M3` from interpreter `SET_SPINDLE_SPEED`/M3 to `EMC_SPINDLE_ON`, `EMCMOT_SPINDLE_ON`, `spindle_status.state`, `speed-out`, `spindle.on` and `spindle.brake`. Which outputs can disagree with a simplistic "0 RPM means OFF" HMI?
2. Explain the difference between **commanded RPM = 0**, **fresh measured RPM = 0**, **normal RUN request = 0**, **mechanical brake physically holding**, **independent protective stop** and **electrical isolation**. None is interchangeable.
3. An operator increases ordinary speed override from zero while a guard is open. Describe the required independent protection and deliberate restart behavior without assuming a particular VFD, motor brake, PL/SIL or stop distance.

## Practical HMI/state contract
| Display label | Provenance required | Never claim |
|---|---|---|
| RPM setpoint | LinuxCNC ordinary speed command | physical standstill |
| RUN request | ordinary `spindle.on` plus selected drive mapping | safe torque off |
| Measured RPM | independent feedback source, timestamp, validity | brake physically holds |
| Brake | requested state and separate qualified physical feedback where needed | load secure from request alone |
| Protective stop/access | selected independent safety chain and final-element evidence | established by G-code or HAL status |
| Maintenance isolation | qualified energy-isolation procedure and verification | achieved by S0 or speed override zero |

**Safer default:** where RUN request remains active at zero setpoint, show **RUN REQUEST ACTIVE — 0 RPM SETPOINT**, not a green **SPINDLE OFF** badge. Make the correct stop/guard procedure easier than changing a speed slider and entering the danger zone.

**Evidence:** SOURCE-CONFIRMED pinned normal-control behavior; DOC-CONFIRMED LinuxCNC 2.9 manual; TEST-CONFIRMED none; physical behavior and selected safety architecture UNKNOWN. No machine actuation, simulator, external scoring or new graduation. OpenPressBrake G0/G1 HOLD remains unchanged.


## Source-depth multi-spindle caveat — SPINDLE-STATE-02
[Exact shared-command-state audit](../research/4400_SPINDLE_STATE_02_LINUXCNC_2910_SHARED_MOTION_COMMAND_STATE_CROSS_SPINDLE_ZERO_SPEED_REARM_SOURCE_AUDIT_2026-10-29.md) identifies a second path: the Task interface reuses one static motion-command object, and a spindle speed update does not explicitly set its ON/OFF field. The source-derived **paper-only** sequence `M5 $0` → `M3 $1` → `S500 $0` can therefore reassert spindle 0's ordinary ON/brake-release state while its canonical direction keeps commanded RPM at **zero**. This is **SOURCE-COMPOSED / NOT TEST-CONFIRMED**; selected hardware and physical motion UNKNOWN. The exact offline discriminator is frozen in the research note, and may run only on a verified isolated self-hosted runner. Do not treat this as a physical machine test recipe or safety permission.

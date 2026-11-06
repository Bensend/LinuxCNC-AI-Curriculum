# PLASMA-250 — QtPlasmaC external-offset motion implementation (2026-11-06)

**Status:** LinuxCNC v2.9.10 SOURCE-CONFIRMED, NON-GRADUATED, runtime and machine behavior NOT tested. Continues [PLASMA-249](3300_LINUXCNC_PLASMA_249_QTPLASMAC_SIM_EOFFSET_HAL_ORDER_2026-11-06.md).

## Immutable upstream provenance
Repository `LinuxCNC/linuxcnc`, tag `v2.9.10`:
- [axis.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/axis.c), Git blob `c5dbdf908c2b9b46e49601700bcee0a4d692721f`
- [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`
- [simple_tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/simple_tp.c), blob `06c8fe04dcbc5907658b0cb0ec1579411182d43a`
- [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c), blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`
- PLASMA-249 independently pins the shipped QtPlasmaC simulator INI/HAL wiring and function order.

## Source-level signal path and control
1. `axis.c:134-140` exports `axis.L.eoffset-enable`, `eoffset-clear`, `eoffset-counts`, `eoffset-scale` as HAL inputs, and `axis.L.eoffset`, `axis.L.eoffset-request` as outputs. `motion.c:693-694` exports aggregate `motion.eoffset-limited` and `motion.eoffset-active`.
2. `control.c:266-269` invokes `get_pos_cmds(period)` **before** `axis_plan_external_offsets(servo_period, motion_enabled, all_homed)`. Therefore newly accepted count deltas are not applied to the already-calculated position command in that invocation, even when a HAL producer runs before motion. In the shipped QtPlasmaC simulator, `plasmac` additionally executes after `motion-controller`: a fresh THC count first becomes visible to motion on a later invocation, and its newly accepted target is then eligible for position calculation on a further invocation. Do not equate this schedule with a measured fixed two-cycle physical delay; interpolation, planner cadence and source-specific update timing matter.
3. `axis.c:481-483` calculates `delta = new_counts - old_counts` and **always updates old_counts**, before enable/homing/motion gating. `axis.c:526-531` adds `delta * eoffset_scale` to the requested target **only if** count delta is nonzero, all axes are homed and motion is enabled. A delta arriving while disabled or unhomed is discarded, not queued for later replay. This is an important diagnostic distinction from accumulating absolute count times scale.
4. `axis.c:497-519`: when `eoffset-enable` is false, the planner is disabled and no new requested target is accepted; this does **not** directly zero the current external offset. `simple_tp.c:47-53` when disabled sets requested velocity to zero and resets target to current position; velocity still ramps subject to acceleration and position is integrated (`simple_tp.c:60-74`). Thus **disabling is not equivalent to immediately removing an applied offset**. `axis.c:521-524` eoffset-clear resets the *requested* target to zero when enabled, but does not instantaneously force current position to zero.
5. `axis.c:473-477` applies configured external-offset velocity/acceleration ceilings to the per-axis `simple_tp` planner. `simple_tp.c:30-75` calculates stopping-aware requested velocity, clamps to max velocity, ramps at max acceleration per period, and integrates position. `axis.c:193-201` exposes setters for these ceilings. PLASMA-249's `OFFSET_AV_RATIO=0.5` is a **configuration-level allocation**; exact INI-to-setter math is a separate follow-up, not assumed from this trace.
6. `axis.c:573-617` updates offset planner and adds its current position to coordinated Cartesian command, then clamps to axis min/max; on violation it adjusts current offset, cancels outward target growth and zeroes offset velocity. `axis.c:622-651,654-685` performs combined teleop+offset bound checking. `control.c:1343-1347,1398-1401,1563-1567` maps these violations to `motion.eoffset-limited`. This is software travel-limit behavior, **not independent personnel-safety protection**.
7. `axis.c:485,493-495` publishes `axis.L.eoffset` and derives aggregate active status from offset magnitude above a small acceleration/period-based epsilon. `control.c:268` writes `motion.eoffset-active` from that result. These status outputs are not identical to the requested count target and should be graphed separately. `control.c:895-903` initializes external offsets when motion is re-enabled.

## Worked, falsifiable example
With `eoffset-scale = 0.01 mm/count`, counts 100→120 during enabled/all-homed operation produce a **requested increment of +0.20 mm**, not an instantaneous +0.20 mm applied move. The actual offset approaches the new target under configured velocity and acceleration limits. If counts advance 120→130 while motion is disabled, the +0.10 mm is consumed by the count-delta tracker but not added to target; simply re-enabling with counts still 130 should not replay it. This is a source-derived prediction, not a test result.

## Practical diagnostic walkthrough (simulation only; not executed)
Use the exact PLASMA-249 metric simulator and log at servo cadence: `plasmac.z-offset-counts`, `axis.z.eoffset-counts`, `axis.z.eoffset-enable`, `axis.z.eoffset-clear`, `axis.z.eoffset-scale`, `axis.z.eoffset-request`, `axis.z.eoffset`, `motion.eoffset-active`, `motion.eoffset-limited`, Z command/feedback and all-homed/motion-enabled state. First verify thread ordering from the loaded HAL, then apply small bounded count steps at rest and observe target versus actual. Repeat with enable false, with motion disabled, and near a **simulated** Z soft limit. Never drive an actual torch or Z axis from this exercise. Predeclare acceptance criteria: (a) delta-based target increments; (b) no disabled/unhomed replay; (c) bounded acceleration ramp; (d) soft-limit saturation and limited flag; (e) distinguish request/status publication timing. If observations differ, inspect actual simulator thread/INI and pin samples before asserting a source defect.

## Evidence ledger and unresolved dependencies
| Proposition | Classification | Evidence / boundary |
|---|---|---|
| Delta*scale, gated by all-homed and motion-enabled | SOURCE-CONFIRMED | axis.c 481-531; no runtime |
| Disabled offset may persist rather than snap to zero | SOURCE-CONFIRMED | axis.c 497-519; simple_tp.c 47-74; exact physical decay unmeasured |
| Velocity/acceleration constrained motion | SOURCE-CONFIRMED | axis.c 473-477; simple_tp.c 16-75 |
| Coordinated/teleop soft-limit interaction | SOURCE-CONFIRMED | axis.c 573-685; control.c 1343,1399,1563 |
| Newly accepted count target not used by earlier same-invocation get_pos_cmds | SOURCE-CONFIRMED ordering | control.c 266-269; simulator's producer-after-consumer adds separate delay |
| Exact cycle-to-cycle latency and actual THC motion | UNVERIFIED | Requires timestamped simulator execution and physical-machine evidence separately |
| INI OFFSET_AV_RATIO setter calculation | OPEN | Trace INI parser and motion command configuration |
| Actual Mesa QtPlasmaC ADC/HAL wiring | OPEN | Requires full real INI/HAL and hardware provenance |

## Reproduce source inspection
```sh
git -C linuxcnc show v2.9.10:src/emc/motion/axis.c | sed -n '460,618p'
git -C linuxcnc show v2.9.10:src/emc/motion/control.c | sed -n '245,275p'
git -C linuxcnc show v2.9.10:src/emc/motion/simple_tp.c | sed -n '16,75p'
git -C linuxcnc rev-parse v2.9.10:src/emc/motion/axis.c
```

**Next:** PLASMA-251 trace `OFFSET_AV_RATIO` INI → motion configuration setter with immutable source blobs; if source value is exhausted, rotate to plasma DXF/CAM or HostMot2. Preserve existing graduation/blind-evaluation and independent personnel-safety gates. No compute, GitHub Actions, builds, simulations or physical-machine activity performed.

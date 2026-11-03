# MOTION-192 — Axis simulation HAL feedback provenance (2026-11-03)

**Status:** SOURCE-CONFIRMED configuration text, NON-GRADUATED. No LinuxCNC process, G-code, realtime thread, or hardware was run.

## Recovered path and pinned evidence

The v2.9.10 `configs/sim/axis/axis.ini` contains `HALFILE = core_sim.hal`, but the file is **not** under `configs/sim/axis/`. It resolves to the shared `lib/hallib/core_sim.hal` (the prior lookup at `configs/sim/axis/core_sim.hal` was a path-resolution error, not missing simulation wiring).

Pinned upstream source:
- [axis.ini, v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/axis.ini)
- [core_sim.hal, v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/core_sim.hal)
- [axis_mm.ini, v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/axis_mm.ini)

`axis.ini` sets `[KINS] KINEMATICS = trivkins; JOINTS = 3`, `[EMCMOT] EMCMOT = motmod; SERVO_PERIOD = 1000000; BASE_PERIOD = 0`, `[TASK] CYCLE_TIME = 0.001`, and `[DISPLAY] CYCLE_TIME = 0.100; POSITION_FEEDBACK = ACTUAL`. These are configured/requested periods, **not measured scheduling jitter**. The millimeter variant also loads `core_sim.hal` but uses different linear units and limits; do not compare P/Q numeric values across them without unit conversion.

## Exact HAL trace

```hal
loadrt [KINS]KINEMATICS
loadrt [EMCMOT]EMCMOT base_period_nsec=[EMCMOT]BASE_PERIOD servo_period_nsec=[EMCMOT]SERVO_PERIOD num_joints=[KINS]JOINTS
addf motion-command-handler servo-thread
addf motion-controller servo-thread
net Xpos joint.0.motor-pos-cmd => joint.0.motor-pos-fb ddt_x.in
net Ypos joint.1.motor-pos-cmd => joint.1.motor-pos-fb ddt_y.in
net Zpos joint.2.motor-pos-cmd => joint.2.motor-pos-fb ddt_z.in
```

**Key distinction:** `joint.N.motor-pos-fb` is wired to the **same HAL signal** as `joint.N.motor-pos-cmd`. The simulated feedback is a direct command loopback, not a motor, drive, encoder, external sensor, or independently measured position. Therefore a zero/small command-versus-feedback error is **not** evidence of tracking accuracy, dynamics, backlash, drive stability, or physical contour fidelity. Even the AXIS `POSITION_FEEDBACK = ACTUAL` setting does not make this feedback physically independent.

The `ddt` components differentiate commanded X/Y/Z positions, and `hypot` combines velocities. Their output is a derivative of the simulated command signal, **not** independently measured velocity. `iocontrol.0.user-enable-out` is looped back to `iocontrol.0.emc-enable-in`; tool prepare/change acknowledgments are also looped back. This is a software simulation convenience and cannot establish an independent personnel-safety or toolchanger-completion chain.

## Measurement design: separate three observables

1. **Canonical emission:** compare G64 P-only and G64 P/Q using interpreter canonical output or message instrumentation, not the AXIS plotted path alone. Prior MOTION-190/191 source confirms Q affects canonical joining, P affects TP blending.
2. **Servo command:** sample `joint.0.motor-pos-cmd`, `joint.1.motor-pos-cmd` and motion status at a common realtime boundary; record sample period, dropped rows, G-code sequence and units. Distinguish TP command trajectory from original G-code geometry.
3. **Independent response:** use a deliberately separate simulated plant with its own state/delay and feedback wiring, or a qualified encoder in a later physical gate. Do **not** call loopback feedback a measurement of following error. A plant fixture needs a known transfer function and perturbation, plus timestamped true-state output.

## Review-only minimal geometry program (not executed)

Use an **inch-configured** copy of `axis.ini`, bounded inside limits, with suitable feed/acceleration. Reset/rehome and run each case separately; do not assume changing G64 within one file preserves earlier buffered points.

```ngc
G20 G17 G90 G94
G0 X0 Y0 Z0
G64 P0.02 Q0
F30
G1 X1 Y0
G1 X1.05 Y0.005
G1 X1.10 Y0
G1 X2 Y0
M2
```

Compare separate variants `G64 P0.02`, `G64 P0.02 Q0`, and `G61` with identical geometry and startup. Predicted from pinned canonical source (not observed): P-only implies Q=P and may merge sufficiently near-collinear segments; explicit Q0 prevents that canonical joining while leaving P blending; G61 changes termination mode. **Do not predict an exact number of emitted segments or exact corner error without evaluating the full joining algorithm and execution.** A fourth variant inserting a repeated G64 between G1 blocks tests the canonical flush boundary. Use independent canonical-output capture to discriminate a segment-count change from servo blending.

## Failure/validity gates

- `HALFILE` resolution: resolve shared `lib/hallib` paths rather than inferring missing files from local directory.
- A loopback feedback trace must be labeled `SYNTHETIC_COMMAND_LOOPBACK`; it is not an actual machine-position oracle.
- GUI redraw period, Task cycle and servo period are distinct. GUI screenshots alone cannot prove cycle-accurate behavior.
- Do not claim a numerical G64 tolerance in mm while using an inch INI.
- No execution until the existing MOTION-144 isolation prerequisite is independently checked and only permitted `[self-hosted, openpressbrake]` compute is used. No hosted runners, machine movement or safety-gate changes.

## Evidence ledger and next questions

| Claim | Status | Basis |
|---|---|---|
| Shared HAL path is `lib/hallib/core_sim.hal` | SOURCE-CONFIRMED | pinned upstream file |
| Three joint command-to-feedback nets are direct loopback | SOURCE-CONFIRMED | pinned HAL `net` statements |
| Simulated feedback validates motor tracking | **FALSE** | no independent plant/sensor |
| G64 geometry differences measured on this config | NOT TESTED | review-only fixture |
| HAL realtime scheduling meets 1 ms deadline | NOT TESTED | INI only |
| Tool-change/estop loopback is independent safety | **FALSE** | pinned HAL topology |

**Next checkpoint:** source-inspect `lib/hallib/basic_sim.tcl` and one real Mesa stepgen/encoder config, identify a reproducible plant/independent-feedback test configuration, and verify which upstream interpreter fixtures expose canonical segment count. Freeze oracle before permitted execution. Keep graduated levels and evaluator separation unchanged.

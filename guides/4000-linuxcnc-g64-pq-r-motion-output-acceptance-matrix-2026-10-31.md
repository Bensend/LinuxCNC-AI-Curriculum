# 4000 — LinuxCNC G64 P/Q/R, canonical geometry and synchronized-output acceptance

**Purpose:** reproducible LinuxCNC-first software-only acceptance for CAM-generated contours and plasma/router/OpenPressBrake-adjacent motion outputs. Read [TP-30](../research/4400_LINUXCNC_TP_30_G64_P_Q_NAIVECAM_CANONICAL_GEOMETRY_AND_IO_BOUNDARY_SOURCE_AUDIT_2026-10-31.md) and [TP-31](../research/4400_LINUXCNC_TP_31_DEVELOPMENT_G64_R_PLANNER_SWITCH_DEFER_AND_REJECTION_SOURCE_AUDIT_2026-10-31.md) before interpreting a result. **SOURCE-DEFINED, NOT EXECUTED.** No physical outputs or production safety claim.

## Two independent surfaces

**Stable v2.9.10:** `G64 P` controls blending tolerance; `Q` controls canonical naive-CAM line/XY-arc simplification. Q omitted inherits P when P is supplied. `G64 P0 Q0` is not `G61.1`. `M62/M63` flush buffered canonical geometry and stage a DIO value for the next motion segment, but do not impose exact-stop positioning.

**Pinned development `24e84c4`:** adds optional `G64 R` planner intent and S-curve aggressiveness; R omitted leaves planner mode unchanged. A planner switch can remain pending until the coordinated queue is empty; a smooth-request rejection can produce an operator error without turning the G64 term-condition Task command into an error. Stable v2.9.10 has no corresponding inspected R implementation. Never silently send development-only G-code to a stable machine.

## Minimal disconnected G-code fixture (stable-compatible)

Create separate copies with only the G64 line changed, rather than chaining multiple tests into one motion program:

```ngc
(trajectory-geometry-only; disconnected sim)
G21 G17 G90 G94
G64 P0.05 Q0.02
G0 Z5
G0 X0 Y0
G1 Z0 F300
G1 X10 Y0 F600
G1 X20 Y0.01
G1 X30 Y0
G0 Z5
M2
```

Variant A: `G64 P0.05 Q0.02`. Variant B: `G64 P0.05 Q0.001`. Variant C: `G64 P0.05`. Variant D: `G64 P0.05 Q0`. Variant E: `G61.1`. Check the **canonical motion messages**, not only preview or plotted joint feedback. The G1 trio can collapse into one straight move in A/C; B/D do not meet the same chain condition. E requests exact stops (not merely a smaller P).

For an IO-boundary discriminator, insert `M62 P0` between the first and second X/Y feed lines, use an unconnected simulated DIO, and capture motion `motion.digital-out-00` and the active TP segment at servo resolution. Repeat with `M62 P0` followed immediately by `M63 P0` before the same next motion. Distinguish the **canonical flush**, **queued segment start**, **parabolic overlap/status selection**, and **actual HAL output transition**. Do not expect a pulse from two same-index commands without an intervening motion.

## Development-only G64 R fixture

On an isolated development simulator with explicit `[TRAJ]PLANNER_TYPE`, `SMOOTH_PLANNER`, `MAX_LINEAR_JERK` and per-axis `MAX_JERK`, run a short preamble `G64 P0.05 Q0.01 R0.5` while motion is known idle. Observe active realtime planner and peak scale. Compare `R0`, `R0.1`, `R1.0`, R omitted and `SMOOTH_PLANNER=0`. The busy-queue case needs a harness that **proves** command arrival while queue depth is nonzero; a mid-program line is not sufficient evidence. Do not create a CI workflow unless a verified isolated `[self-hosted, openpressbrake]` runner is available; no hosted fallback.

## Required evidence package before promotion

Record exact LinuxCNC commit/binary, selected INI/HAL, G-code, canonical command trace, TP queue and active segment, DIO HAL trace, planner type/scale, operator errors, stdout/stderr, exit code, and authoritative runner job timestamps. State whether a result is source-only, simulation-tested or physically tested. Retain negative and failed runs. If any timing measurement uses a userspace poll, do not call it a same-servo-cycle measurement.

## Machine-application boundary

For a plasma torch, output timing must be characterized against the actual motion/HAL cycle and physical process delay; M62 is not an encoder latch. For a press brake, these are **ordinary motion/control** observations, not permission to use LinuxCNC as personnel-safety authority. Preserve independent safety gates and existing evidence. No required CAD/CAM product build is implied.

# 4000 — G93 feed metric, development FEED_AXES and G5 spline acceptance
**Review-only; all 19 tests NOT RUN.** Source audits: [G93-67](../research/4400_LINUXCNC_G93_67_INVERSE_TIME_ZERO_FEED_CUTTER_COMP_SOURCE_AUDIT_2026-10-31.md), [FEED-68](../research/4400_LINUXCNC_FEED_68_DEVELOPMENT_FEED_AXES_CANON_MOTION_METRIC_SOURCE_AUDIT_2026-10-31.md), [SPLINE-69](../research/4400_LINUXCNC_SPLINE_69_G93_F_PRESENT_BUT_NOT_APPLIED_G5_SOURCE_AUDIT_2026-10-31.md).

## Environment and evidence gates
Use only a disconnected LinuxCNC simulation on an approved **[self-hosted, openpressbrake]** runner, if its isolation and runner identity have been positively verified. Never use GitHub-hosted Actions. Do not attach Mesa/EtherCAT/VFD/spindle/probe/torch/hydraulics. Preserve LinuxCNC commit/tag, build command, INI/HAL, G-code, source/fixture SHA, stderr, canonical command stream, realtime status/trajectory and timestamps. A Python model of the arithmetic or a static source trace is **not** an independent LinuxCNC runtime oracle. If qualified compute is unavailable, retain all cases as NOT RUN.

### Minimal program skeleton
```ngc
G21 G90 G17 G40 G94
G0 X0 Y0 Z0
G93
G1 X10 F2
G94 F100
M2
```
This is **software-only** NC. Run each variant with a fresh interpreter/controller state; do not concatenate conflicting modal cases without a reset.

| Case | Fixture / change | Expected source oracle | Required independent runtime witness |
|---|---|---|---|
| G1 | G93 G1 X10 F2 | enqueue rate 20 mm/min; nominal 30 s | canonical rate and measured simulated duration |
| G2 | G93 G1 X10 with **no F** | interpreter rejects missing inverse-time F | error line and no unintended motion command |
| G3 | G93 G1 X10 F0 | F-presence passes; zero canonical rate; ordinary unsynchronized feed omitted while canonical endpoint advances | canonical list/endpoint and Task/motion status |
| G4 | G93 G1 X0 F100 from X0 | zero-length special rate 0.1 | canonical rate and whether motion omitted |
| G5 | G93 G1 A90 F2 (A angular) | rate 180 deg/min, 30 s nominal | angular canonical rate, axis-limited time |
| G6 | G93 G1 X10 A90 F2 | measured length 10 mm; A not part of F metric | A-axis max-velocity bottleneck / actual time |
| G7 | G93 G3 X-10 Y0 I-10 J0 F2 from X10 Y0 | CCW semicircle length 10π mm; rate 20π mm/min | arc direction/geometry, canonical F, timing |
| G8 | G94 then G1 X20 without fresh F | G94 feed reset to zero; interpreter rejects | explicit parser error |
| F1 | development: G94 F60 X10 U10, FEED_AXES=XYZ vs XYZU | metric 10 vs 14.142 mm; requested time 10 vs 14.142 s | canonical and motion rates/time |
| F2 | development: G93 F2 X10 U10, same INI pair | canonical rate 20 vs 28.284 mm/min; both nominal 30 s | `motionLengthRatio`, `vlimit_scale`, time |
| F3 | development FEED_AXES=XYZA with A ANGULAR | INI validation rejects angular member | startup error and no controller motion |
| F4 | development A TYPE=LINEAR, V TYPE=ANGULAR | A-only length treated linear, V-only angular | `tests/interp/axis-type` behavior with pinned test INI |
| S1 | G93 G5 I0 J3 P0 Q-3 X1 Y1 F2 vs F200, same prior feed | no per-spline F-to-rate conversion in inspected path | canonical SET_FEED_RATE event diff, spline timing |
| S2 | repeat S1 with G5.1 X1 Y1 I0 J3 | same F-presence-only path | same independent oracle |
| G9 | G93 G1 X10 F0 then G1 X20 F2 | first normal feed omitted, canonical endpoint advanced; next F based on 10 mm | canonical and Task motion-command trace |
| S3 | fresh G93 G5/G5.1 F2 without preceding positive feed | F present but no new rate; zero-velocity spline segments may be omitted while endpoints advance | canonical events and endpoint; no physical inference |

| T1 | G93 G1 Z0 A90 F5 (fresh) | pure rotary length 90 deg, rate 450 deg/min | canonical classification, measured duration |
| T2 | G93 G1 Z0.00000005 A90 F5 (metric) | interpreter rotary-only at 1e-7 cutoff, canonical mixed at 1e-8 cutoff | interpreter feed, canonical metric, Task motion and time |
| T3 | G93 G1 Z0.0000002 A90 F5 (metric) | both classify XYZ as moving; length 2e-7 mm in interpreter | rates, numerical preservation, runtime |

**T1–T3 provenance:** [G93-70 tiny-displacement source/community audit](../research/4400_LINUXCNC_G93_70_TINY_LINEAR_ROTARY_THRESHOLD_SOURCE_COMMUNITY_AUDIT_2026-10-31.md) reconciles upstream 2023 issue #2410, its May 2023 fix and remaining source thresholds. All T cases are NOT RUN; do not claim the historical issue recurred.

**G7 geometry frozen:** Start X10,Y0; end X-10,Y0; center offset I-10,J0. G3 is a CCW semicircle of radius 10. Source-computed length is 10π mm, G93 F2 rate is 20π mm/min. Verify modal start state before scoring.

## Readiness, limits, next action
Static arithmetic is SOURCE-CONFIRMED; upstream tests and demos were inspected but not executed here. Runtime, HAL, hardware and physical acceptance remain UNKNOWN. Start with G1–G4 and S1 only after runner qualification; they discriminate parser F acceptance versus canonical rate. Do not manufacture a new graduated level or count a GUI preview as independent motion proof.

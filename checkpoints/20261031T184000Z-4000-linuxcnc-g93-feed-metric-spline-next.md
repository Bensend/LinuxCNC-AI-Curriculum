# 2026-10-31 18:40Z — G93/FEED_AXES/spline continuation
**Active 4000 / NON-GRADUATED.** 1000/2000/F02/3000 CLOSED; independent evaluator OPEN; OpenPressBrake physical G0/G1 HOLD. Hourly curriculum remains enabled.

## Governance and predecessor
Started at 2026-10-31T18:35:14Z; read START_HERE, README, mission, level order, work selection (LinuxCNC-first owner override), curriculum, source/template, PROGRESS, blind-feedback protocol/score, compute ledger and prior SPINDLE-64/ROUTER-65/MESA-66 checkpoint. Novelty scan of full PROGRESS found no prior G93, inverse-time, FEED_AXES or axisKinds source trace; G95 and CAM lead-in topics already covered. No external blind result or qualified isolated compute.

## Durable source work
- [G93-67](../research/4400_LINUXCNC_G93_67_INVERSE_TIME_ZERO_FEED_CUTTER_COMP_SOURCE_AUDIT_2026-10-31.md): G93 F per-block length×F; exact-zero-length rate 0.1; F0 passes interpreter F-presence check but downstream unknown; G94/G95 reset feed; compensated path length and mixed rotary may defeat nominal time.
- [FEED-68](../research/4400_LINUXCNC_FEED_68_DEVELOPMENT_FEED_AXES_CANON_MOTION_METRIC_SOURCE_AUDIT_2026-10-31.md): v2.9.10 hard-coded XYZ/UVW/ABC; development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` adds `FEED_AXES`, axis TYPE and shared interpreter/canonical metric with `motionLengthRatio` adapter. G94 vs G93 numerical discriminators; upstream axis-type fixture inspected.
- [SPLINE-69](../research/4400_LINUXCNC_SPLINE_69_G93_F_PRESENT_BUT_NOT_APPLIED_G5_SOURCE_AUDIT_2026-10-31.md): stable and development G5/G5.1 G93 path checks F presence but does not consume F value to calculate a new canonical feed; biarc expansion uses existing feed. Conditional CAM compatibility risk, not a demonstrated G93 docs violation.
- [16-case disconnected guide](../guides/4000-linuxcnc-g93-feed-metric-spline-disconnected-acceptance-2026-10-31.md) includes frozen independent oracles and a geometry caution. **ALL NOT RUN.**

## Same-session source-depth correction
A full stable/development canonical trace of `flush_segments` and `ARC_FEED` found that a nonsynchronized zero-velocity move is **omitted** from the command list while the canonical endpoint advances. This strengthens G93-67 F0 from unknown downstream to **source-confirmed canonical omission**, with integrated Task and physical consequences still untested. G93 G5/G5.1 with no prior positive feed can have the same omission. Guide expanded to 16 cases (G9/S3); G7 geometry corrected to G3 semicircle.

## Precise next checkpoint
1. If approved, positively isolated `[self-hosted, openpressbrake]` runner is available, run bounded software-only G1–G4, G9, S1 and S3 with stable v2.9.10 and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`, capturing canonical `SET_FEED_RATE` events, parser error, Task and realtime outcome. Verify G7 arc geometry before scoring; no hosted runner or physical I/O.
2. If compute remains unavailable, rotate to another distinct LinuxCNC implementation topic (e.g. tool-table persistence, real mill/lathe toolchange, FPGA stepgen index timing) rather than repeating G93 source analysis. Do not reopen closed levels or create busywork.
3. Preserve independent personnel safety, blind evaluator separation, OpenPressBrake physical HOLD. Do not claim test evidence or edit compute/feedback ledgers absent new authoritative results.

**Evidence:** SOURCE/DOC-CONFIRMED static, conditional INFERENCE, TEST-CONFIRMED none. No build/simulation/hardware/Actions; hosted/self-hosted Actions 0/0 min. Lesson end 2026-10-31T18:39:33.995Z; no authoritative job runtime.

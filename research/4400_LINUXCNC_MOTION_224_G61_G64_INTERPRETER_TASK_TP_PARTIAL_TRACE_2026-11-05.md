# MOTION-224 — G61/G61.1/G64 interpreter-to-planner termination trace (4000, NON-GRADUATED)

2026-11-05 01:39 UTC. Continuation of MOTION-223; no new machine or runtime evidence.

## Immutable source provenance (LinuxCNC v2.9.10)
- [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `Interp::convert_control_mode` lines 1633 onward.
- [emctaskmain.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc), blob `7292a172023a5b42b023447c2458cb766c93fc9b`, command dispatch lines 1877–1880.
- [motion/command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), blob `0b79061d39be915bbea548b2c33bb794d31ab302`, lines 983–987.
- [tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`, `tpSetTermCond` lines 638–660 and MOTION-223.
- The intermediate canonical command producer, `emcTrajSetTermCond` implementation and exact enum translation have NOT been independently inspected in this session. This is an explicitly **partial** end-to-end trace, not a fabricated complete call chain.

## Verified stages
1. Interpreter `convert_control_mode` rejects changing mode while cutter radius compensation is active. G61 calls `SET_MOTION_CONTROL_MODE(CANON_EXACT_PATH,0)`; G61.1 calls `(...CANON_EXACT_STOP,0)`; G64 normalizes absent/negative path tolerance to zero, stores continuous mode and tolerance, and calls `(...CANON_CONTINUOUS,tolerance)`. Its separate naive-CAM tolerance handling follows that call; do not conflate P and Q.
2. Task handles `EMC_TRAJ_SET_TERM_COND_TYPE` by calling `emcTrajSetTermCond(cmd->cond,cmd->tolerance)`. Task precondition dispatch places this command in the `WAITING_FOR_IO` category, not the motion-and-IO wait category.
3. Motion command dispatch handles `EMCMOT_SET_TERM_COND` by passing `termCond,tolerance` to `tpSetTermCond(&coord_tp,...)`. The planner stores termination condition and tolerance for subsequent queued moves. No inference of a specific geometric blend is justified from mode alone.

## Reproducible disconnected exercise
At v2.9.10, inspect the four pinned blobs and locate `convert_control_mode`, `EMC_TRAJ_SET_TERM_COND_TYPE`, `EMCMOT_SET_TERM_COND`, `tpSetTermCond`. Separately locate the canonical `SET_MOTION_CONTROL_MODE` definition/implementation and `emcTrajSetTermCond` in the same tag before claiming enum parity. For a complete follow-up, trace `P` and `Q` parsing and the planner's actual geometric blend/deviation test.

## Two-segment corner fixture (prediction, NOT execution)
```gcode
G21 G90 G17
G0 X0 Y0
G64 P0.10 Q0.10
G1 F600 X10 Y0
G1 X10 Y10
M2
```
The 90-degree vertex is (10,0) mm. Nominal feed is 600 mm/min = 10 mm/s. If a geometric blending algorithm replaces the vertex by a circular fillet tangent to both segments with radius r, its maximum deviation from the original *polyline* at the bisector is `r(1-1/sqrt(2))`; a 0.10 mm deviation corresponds to `r≈0.3414 mm` **for that assumed fillet geometry**. This is a mathematical illustration, **not** a prediction that LinuxCNC chooses that radius or corner speed. Acceleration, queue context, P/Q semantics and planner algorithms determine actual results.

Comparison fixtures: replace `G64 P0.10 Q0.10` with `G61`, then `G61.1`. Predict mode mapping from interpreter; do **not** predict exact corner velocity without planner trace or runtime. Do not use on physical equipment without independent review.

## Review questions and falsifiers
- Does changing mode under cutter compensation succeed? Inspected interpreter says no; a version-matched accepted case would falsify this claim.
- Is G61.1 mapped to exact path? No: exact stop. Source-specific.
- Does `G64 P0.10` guarantee 0.10 mm deviation or a particular feed at corner? No; source trace does not establish either.
- Does Task directly invoke `tpSetTermCond`? No; Task calls `emcTrajSetTermCond`, motion dispatch calls `tpSetTermCond`.
- Are the canonical enum values and full forwarding chain established here? No; bridge is pending.
- Does a simulated trajectory trace verify the fillet formula for LinuxCNC? No; analytical geometry only.

## Evidence and gates
SOURCE-CONFIRMED: four narrow source sites. ANALYTICAL: conditional fillet formula. UNKNOWN: intermediate canonical/Task-to-motion conversion, geometric tolerance enforcement, actual corner velocity, development-branch parity. TEST-CONFIRMED: none. No builds, simulations, GitHub Actions, compute, or machine activity. Historical compute ledger inspected; no new compute runtime. Independent personnel-safety authority, graduated levels, blind evaluator separation and physical gates unchanged.

## Next checkpoint
Close the missing `SET_MOTION_CONTROL_MODE` → `EMC_TRAJ_SET_TERM_COND` → `emcTrajSetTermCond` → `EMCMOT_SET_TERM_COND` bridge with pinned v2.9.10 source. Inspect Q/naive-CAM and planner blend geometry before offering a measured corner-speed oracle. If already covered by MOTION-191, rotate to homing internals or real mill/plasma configuration.

# 4000-LC-FEED-68 — Development FEED_AXES: interpreter, canonical metric and motion re-scaling
**2026-10-31; active 4000 / NON-GRADUATED; static source and documentation only.**

## Version boundary
The stable [v2.9.10 `interp_find.cc::find_straight_length`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_find.cc#L644) uses a hard-coded three-tier distance rule: XYZ if any XYZ moves; otherwise UVW if any UVW moves; otherwise ABC. Stable [INI documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/ini-config.adoc) contains no `FEED_AXES` entry, and `include/axis_kinds.hh` does not exist at this tag.

Pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` adds [`include/axis_kinds.hh`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/include/axis_kinds.hh) (blob `3b75602934727e75a4908f66a77c4f9bbbb3a3cb`), [`interp_find.cc::find_straight_length`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_find.cc#L769) (blob `758e0fd62dc08c3d50be07b5ef14c3fb5a0a716a`), [INI FEED_AXES documentation](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/ini-config.adoc#L936) and [feed semantics](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/gcode/machining-center.adoc#L173). This is a **development-only inspected feature**, not a v2.9.10 option.

## New metric
`axisKindsRead` reads `[AXIS_<letter>] TYPE` (default A/B/C angular) and `[TRAJ] FEED_AXES` (default XYZ). It rejects a feed group containing angular axes, an empty/invalid group, or angular X/Y/Z. `axisKindsMeasured(k,moving)` selects: **feed group if any member moves**, else other linear axes, else angular axes. `axisKindsLength` takes the Euclidean norm of the selected deltas. This selection is used in the **interpreter** for G93 and in the **canonical layer** for coordinated motion.

[Interpreter initialization](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/rs274ngc_pre.cc#L857) calls `axisKindsRead` and raises an interpreter error on invalid configuration. [Canonical initialization](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L3503) also reads the INI, but logs an error rather than using the same explicit return path. The installed machine and GUI must use a consistent INI; independent canonical initialization behavior after malformed settings remains a runtime question.

## The non-obvious motion-layer adapter
[Canonical `getStraightSpan`, `motionLengthRatio`, `toMotionLength`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L734) compute a source-program feed metric but account for the realtime motion layer's legacy XYZ→UVW→ABC path-length tiers. `toMotionLength` scales `msg.vel`, `ini_maxvel`, acceleration and jerk by `motionLengthRatio`. It also sets `vlimit_scale = 0` for angular-only measured moves, otherwise the ratio. This is a *metric conversion*, not proof that the motion layer directly adopted the new `FEED_AXES` set.

### Hand-check example (mm machine; source-derived, not run)
Move X0 U0 → X10 U10. Default `FEED_AXES = X Y Z` measures 10 mm; `FEED_AXES = X Y Z U` measures √(10²+10²) = **14.1421356 mm**. At G94 F60 the requested times are respectively **10.000 s** and **14.142 s** absent acceleration/limits. At G93 F2 the inverse-time rate becomes respectively **20.000 mm/min** and **28.284 mm/min**, both nominally **30 s**. In the second case the legacy motion metric is 10 mm, so the canonical ratio is approximately **0.707107** and the motion-message rate is scaled accordingly.

The distinction matters to a CAM post: G94 F is a *path speed* in the configured metric; G93 F is a *duration request*. Simply copying a feed word between modes, or assuming every development configuration measures XYZ only, is wrong.

### Other source-derived cases
- With `[AXIS_A] TYPE = LINEAR`, an A-only 20-unit move can be measured as linear, rather than as degrees. [Upstream axis-type test INI](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/tests/interp/axis-type/test.ini) and [G-code fixture](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/tests/interp/axis-type/test.ngc) demonstrate the intended A-linear/V-angular distinction; tests were **inspected, not executed here**.
- `FEED_AXES = X Y Z A` with default A angular is rejected by `axisKindsRead`; to include A, configure it as LINEAR, and separately verify kinematics and physical semantics.
- The maximum-velocity slider caps the feed-group metric in development per INI docs, but pure angular moves are not capped by that slider. Axis-specific limits still matter.
- Upstream [five-axis impeller G93 program](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/5axis/table-rotary-tilting/demos/impeller-7bl-xyzac.ngc) uses XYZAC and F on each feed; its physical runtime is not known.

## Required verification
On a **positively isolated** development simulation only, compare default versus `FEED_AXES = X Y Z U` with identical G94 and G93 NC blocks. Capture canonical `SET_FEED_RATE`, `EMC_TRAJ_LINEAR_MOVE.vel`, `vlimit_scale`, axis limits, and actual simulated path/time. Reject invalid feed group before running motion. Pin the exact build/INI/NC hash and separate interpreter prediction from realtime results. No qualified compute used in this lesson.

## Open
- Does all production realtime planner behavior preserve intended timing across mixed linear/rotary axes, velocity override and path blending? Not proven.
- Does a configured `TYPE=LINEAR` on an unusual axis agree with physical/kinematic meaning? Requires machine-specific design evidence.
- **No graduation, hardware proof or physical authorization.**

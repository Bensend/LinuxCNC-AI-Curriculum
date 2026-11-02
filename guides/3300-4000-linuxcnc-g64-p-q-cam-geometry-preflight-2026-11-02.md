# G64 P/Q geometry preflight — 3300 plasma, 3100 mill, 3400 router, 4000 CAM integration

**Version and status:** stable LinuxCNC v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` and development `67437d8865e431a9a33f74cee912dbf891d3b4c5`; [source audit](../research/4400_LINUXCNC_G64_Q_164_NAIVECAM_PREFILTER_GEOMETRY_AND_ARC_DOC_SOURCE_AUDIT_2026-11-02.md). All LinuxCNC execution cases **NOT RUN**. Use only a disconnected simulation with a qualified `[self-hosted, openpressbrake]` runner for justified compute. Never GitHub-hosted Actions. **Never run the supplied motion fixtures on a connected machine or OpenPressBrake.**

## Practical purpose

CAM postprocessors may emit thousands of small line segments from DXF/SVG/nesting geometry. G64 P controls trajectory blending of canonical moves; Q can remove vertices *before* those moves reach the planner. These are different error sources; even when Q is omitted and inherits P, the P-only number is not independently established as an overall contour-error bound. For a sharp plasma contour or precision mill/laser/router feature, `P0.01 Q0.5` does not mean the original programmed polyline is held within 0.01 mm. DXF topology, lead-ins, pierce delays, cutter compensation, kerf and nesting remain separate contracts.

## Preflight procedure (no LinuxCNC required)

1. Confirm units in the CAM file (`G20` inches versus `G21` mm), absolute mode, modal feed, and whether the post emits `G64 P...`, `Q...`, bare G64, or no G64. Check `[RS274NGC]` defaults for the installed version; do not assume development defaults on stable.
2. Inspect every G64 mode change. If Q is omitted but P is supplied, Q inherits P in both inspected versions; `Q0` disables naive CAM. Do not treat P and Q as interchangeable if explicitly different.
3. Run `python3 examples/4000_g64_q_164/chord_preflight.py` from repo root (or the script in its folder). Expected `distance=0.199960011996` mm and PASS for `P=0.01, Q=0.5`. This validates arithmetic only, not LinuxCNC.
4. Compare [Q0.5](../examples/4000_g64_q_164/path_q05.ngc) and [Q0](../examples/4000_g64_q_164/path_q0.ngc) in **isolated** LinuxCNC 2.9.10 simulation. Observe Task/canonical queued feed endpoints using a controlled trace or test harness; Axis preview alone is not authoritative for the live Task pipeline. Record the exact revision, configuration, command, trace, result and runtime. Do not infer result from source inspection.
5. Preserve CAD original, post version, G-code, and the simulator's canonical trace. Compute vertex-to-simplified-path deviation independently and compare against the *whole* contour tolerance budget, not P alone.

## Frozen A–H acceptance matrix (NOT RUN)

| ID | Case | Predicted canonical behavior | Evidence needed |
|---|---|---|---|
| A | `G64 P0.01 Q0.5`, A→B→C | one feed move A→C; B bypassed | Task canonical feed endpoints, not GUI-only |
| B | `G64 P0.01 Q0`, same points | two feed moves A→B, B→C | same collector and revision |
| C | `G64 P0.01`, Q omitted | Q defaults to P; two feed moves | compare exact Q state and endpoints |
| D | `G61` before the same contour | no naive-CAM chaining | compare with A; exact-path planner is a separate issue |
| E | change F between B and C | `SET_FEED_RATE` flushes pending chain | feed-change control, count feed moves |
| F | insert G0 between segments | `STRAIGHT_TRAVERSE` flushes chain | trace and start-state control |
| G | [G17 semicircle Q0.5](../examples/4000_g64_q_164/arc_q05.ngc) versus [Q0](../examples/4000_g64_q_164/arc_q0.ngc), r=0.25 mm | Q0.5 source predicts two chord vertices chained to one straight feed; Q0 preserves circular move | Task canonical message types; version, units, geometry |
| H | development G68 active: compare G17 shallow arc and segmented G1 path | G68 disables G17 arc-to-line branch, **not** G1 `linkable` Q merging | dev-only controls; Task canonical message types; do not use on stable |

**Oracle integrity:** Predictions are declared before running. Mark `PASS`, `FAIL`, or `HARNESS INVALID` only from retained evidence. An unconfigured simulator or a GUI screenshot is not an authoritative canonical trace. Tests A–H remain NOT RUN; no grader or blind-evaluation result exists.

## Integration rules for CAM/nesting/press-brake research

For 3300 plasma, check whether postprocessor collinear simplification changes small corners, pierce/lead-in entry points, or narrow features before any torch-specific logic; QtPlasmaC process and independent protective functions remain separate. For 3100/3400, check finishing-contour geometry and compensation lead-in independently of G64. For 3600 OpenPressBrake, investigate DXF bend-line extraction and geometric simplification as *offline calculations only*; the G0/G1 physical interface remains HOLD, and LinuxCNC motion fixtures here do not authorize motion. For ROS/ROS 2 bridge work, expose commanded contour provenance and freshness separately from sampled joint position; never label a preview a verified toolpath.

**Next:** preserve exact A–H results only when qualified, disconnected compute is available. Otherwise rotate to another distinct LinuxCNC source implementation topic. Existing MOTION-144 executable priority precedes this optional experiment.

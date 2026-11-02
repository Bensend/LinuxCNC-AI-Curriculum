# G64-Q-164 — Naive-CAM geometry is a separate tolerance from trajectory blending (2026-11-02)

**Status:** 4000 LinuxCNC-first source investigation; 3300 plasma, 3100 mill, 3400 router, 3600 press-brake CAD/CAM transfer. NON-GRADUATED. **SOURCE-CONFIRMED static; numerical geometry CHECKED independently; LinuxCNC runtime NOT RUN.** No physical machine, LinuxCNC build, external evaluator, or GitHub Actions. This is not a personnel-safety authorization.

## Question and predecessor check

Can a CAM post specify a small `G64 P` path-following tolerance but a larger `G64 Q` naive-CAM tolerance, and thereby change the programmed contour by more than P **before** the trajectory planner sees it? Does the documented G17 arc threshold refer to the same parameter used in code?

This is distinct from [PATH-BLEND-01](../safety-course/4400_PATH_BLEND_G92_01_CLEARANCE_AND_COORDINATE_TRUST_FIELD_CARD_2026-10-28.md) (G0 blend clearance), [CAM-59/60](4400_LINUXCNC_CAM_60_FREECAD_G64_P_UNITS_ORDER_WARNING_BRANCH_SOURCE_AUDIT_2026-10-31.md) (post modal/units), and CAM G64 reset audits. Prior PROGRESS/CURRICULUM/LESSON and lab ledger inspected; no predecessor located for the **P/Q preprocessing geometric-error example**. Do not infer absence from code-search negatives.

## Immutable upstream evidence

Stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`:
- [`src/emc/rs274ngc/interp_convert.cc` — `Interp::convert_control_mode`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc): for G64, P becomes `tolerance`; explicit Q becomes `naivecam_tolerance`; omitted Q defaults to explicit P, otherwise 0. Calls `SET_MOTION_CONTROL_MODE(..., tolerance)` and `SET_NAIVECAM_TOLERANCE(naivecam_tolerance)`.
- [`src/emc/task/emccanon.cc` — `SET_MOTION_CONTROL_MODE`, `SET_NAIVECAM_TOLERANCE`, `linkable`, `see_segment`, `flush_segments`, `STRAIGHT_FEED`, `ARC_FEED`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc). The canonical prefilter buffers feed endpoints; `linkable` checks distance of *each buffered intermediate point* from the candidate start-to-new-end segment against `canon.naivecamTolerance`, and `flush_segments` emits one `EMC_TRAJ_LINEAR_MOVE` at the last endpoint. `SET_FEED_RATE` flushes buffered segments when a new unsynchronized feed differs; `STRAIGHT_TRAVERSE` flushes them before G0.
- [`docs/src/gcode/g-code.adoc` — G64 Path Blending](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc): documents P motion blending, Q naive CAM, Q=0 disabling naive CAM, omitted Q inheriting P. Its G17 arc paragraph nevertheless says the arc's deviation is tested against **G64 P**.
- [`src/emc/tp/tp.c` — `tpSetTermCond`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tp/tp.c): trajectory planner receives its own terminal-condition tolerance; it is downstream of canonical segment simplification.

Development `67437d8865e431a9a33f74cee912dbf891d3b4c5`:
- [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_convert.cc) retains distinct P/Q routing; bare G64 may use configured default P rather than stable zero. It also adds a fork-specific R planner parameter, **not portable to v2.9.10**.
- [`emccanon.cc`](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/task/emccanon.cc) retains `linkable` / `flush_segments` / `chord_deviation` path; G68 tilted-plane active state disables the G17 arc simplification branch.
- [development G64 docs](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/gcode/g-code.adoc) still describe arc deviation threshold as P. Source checks `chord_deviation(...) < canon.naivecamTolerance` (Q), in both inspected revisions. This is a **DOC/SOURCE CONFLICT** for explicitly different P and Q; no claim is made about all other branches.

## Execution path: two different geometry operations

`G64 P0.01 Q0.5` → interpreter `convert_control_mode` → canonical `SET_MOTION_CONTROL_MODE(CANON_CONTINUOUS, 0.01)` (flushes pending chain, queues terminal-condition message) → `SET_NAIVECAM_TOLERANCE(0.5)` (sets canonical prefilter) → subsequent `STRAIGHT_FEED` endpoints → `see_segment`/`linkable` may discard intermediate vertices → `flush_segments` queues a **new straight move** to final endpoint → Task/motion trajectory planner receives that simplified move and its P blending condition. Thus **P is not an overall maximum deviation from the original CAD contour when Q > P**. Q changes geometry before planner interpolation.

In `linkable`, candidate segment is `M=(new_end - canon.endPoint)`, `B=canon.endPoint`; each buffered `P_i` is projected onto that segment with clamped `t` and distance `D=|P_i-(B+tM)|`. The link is allowed when every D <= Q (code rejects only D > Q), subject to continuous mode, nonzero Q, chain length and unchanged ABCUVW; no direct check against P appears here. The next `flush_segments` uses only `chained_points.back()` as destination. A change of feed rate or G0 flushes, so the example intentionally uses one feed and no intermediate modal barrier.

## Reproducible numerical discriminator (source-derived, not a runtime trace)

In mm, program `A=(0,0)` → `B=(10,0)` → `C=(20,0.4)` with one feed rate and `G64 P0.01 Q0.5`. The perpendicular distance of B to segment AC is:

`t = (B-A)·(C-A)/|C-A|² = 200/400.16 = 0.499800079968...`
`foot = A + t(C-A) = (9.99600159936, 0.199920031987)`
`D = |B-foot| = 0.199960011996 mm`.

Because **D < Q=0.5**, the source predicts one canonical feed segment A→C, bypassing programmed vertex B. Because **D > P=0.01** (~20×), the simplified geometric path is already outside the nominal P-only budget at B. This arithmetic was independently checked with Python `math.dist` on 2026-11-02; this is **NUMERIC-CHECKED, not LinuxCNC TEST-CONFIRMED**. `G64 P0.01 Q0` is the negative control: `linkable` rejects the merge, leaving two feed segments. A planner may further deviate from its received path under its own tolerance; the source example does not establish a global error bound or actual cut accuracy.

## G17 arc threshold: distinct documentation discrepancy

Both inspected `ARC_FEED` implementations calculate `chord_deviation` and compare it to `canon.naivecamTolerance` (the Q value). If the deviation is below Q, the G17 arc is emitted as two linear segments via `see_segment`; those may subsequently be chained. Both inspected G64 docs instead say the initial arc conversion threshold is P. When Q is omitted, Q defaults to P and the discrepancy is hidden. `G64 P0.01 Q0` disables this arc simplification in the inspected code even if a G17 arc's deviation is below P. Development disables this path under active G68 tilted work plane. Note that `chord_deviation` is a 2D XY test, not a certified 3D toolpath-error bound for all helical/multiturn cases.

## Same-session follow-through — source-line attribution and real plasma CAM provenance (164B)

The stable `flush_segments` implementation takes `pos = chained_points.back()`, then assigns both `line_no = pos.line_no` and `tag_and_send(linearMoveMsg, pos.tag)` from **the final retained endpoint**. Intermediate buffered vertices do not become individual canonical move messages. **SOURCE-CONFIRMED:** when a chain merges, the resulting canonical motion's line/tag attribution comes from the final buffered segment. **INFERENCE:** downstream diagnostics keyed only to canonical move line numbers can omit earlier G-code vertex line numbers; no Task or GUI runtime trace was collected. This is another reason to preserve original CAM line provenance separately from Task motion traces.

An actual upstream LinuxCNC plasma fixture, [`tests/trajectory-planner/circular-arcs/nc_files/XYtests/51MeanderAve.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/trajectory-planner/circular-arcs/nc_files/XYtests/51MeanderAve.ngc), identifies a LinuxCNC plasma.scpost and includes `G64 P0.01 q00.01`, mixed G0/G1/G3, M3/M5 and dwell commands. This is **SOURCE-CONFIRMED real example of CAM-specified P and Q**, not proof of any Q>P failure in that fixture and not permission to run it on a machine. It supports a practical workflow: audit emitted G64 settings at the **postprocessor output**, not only CAD geometry or the controller's default. The sample's 2014 embedded date is file text, not independently verified Git publication time. No additional lab compute.

## Same-session G17 numerical discriminator (164C)

A second bounded fixture makes the P-versus-Q arc documentation discrepancy visible without relying on a long CAM program. In G17/G91.1, start A=(0,0), execute clockwise `G2 X0.5 Y0 I0.25 J0` (center (0.25,0), radius 0.25 mm). The included angle is π; `chord_deviation` computes `r*(1-cos(π/2))=0.25 mm`. Under `G64 P0.01 Q0.5`, source condition `0.25 < Q` is TRUE, so `ARC_FEED` submits midpoint (0.25,0.25) and endpoint (0.5,0) to `see_segment`. `linkable` then checks midpoint distance 0.25 mm to the A→end chord, also <=Q, and can reduce the **entire semicircle to one straight feed move**. Under `G64 P0.01 Q0`, the arc conversion condition is false and the canonical circular move is retained. This is **SOURCE-DERIVED / ARITHMETIC**, **NOT A LINUXCNC RUNTIME OBSERVATION**. Fixtures: [Q0.5](../examples/4000_g64_q_164/arc_q05.ngc) and [Q0](../examples/4000_g64_q_164/arc_q0.ngc), both disconnected simulation only. The example is intentionally tiny to isolate the logic, not a proposed plasma hole size.

## Review-only upstream documentation correction (164D)

[Stable v2.9.10 documentation patch](../examples/4000_g64_q_164/stable_2910_g64_pq_doc_clarification.patch) clarifies that P applies to trajectory blending of canonical moves, while a larger Q may alter programmed geometry upstream, and corrects the G17 arc-threshold reference from P to Q. The exact old lines were fetched from the pinned `docs/src/gcode/g-code.adoc` at lines 1737–1751. This is **a proposal**, not an applied upstream change, and has not been compiled, rendered or evaluated by upstream maintainers.

## Claims and limits

| Claim | Classification | Scope | Independent verification |
|---|---|---|---|
| P and Q route to different canonical controls | SOURCE-CONFIRMED | stable+dev pinned | source readback only |
| `linkable` can merge A→B→C with D≈0.19996 at Q0.5 | SOURCE-CONFIRMED mechanism + NUMERIC INFERENCE | stable+dev pinned | Python geometric arithmetic, not LinuxCNC |
| P0.01 cannot guarantee original-contour error ≤0.01 if Q0.5 | SOURCE-CONFIRMED mechanism / conditional INFERENCE | both pinned | actual Task canonical trace NOT RUN |
| G17 arc simplification compares Q while docs say P | SOURCE/DOC-CONFLICT | both pinned | runtime discriminator NOT RUN |
| Exact physical toolpath deviation/cut kerf | UNKNOWN | machine-dependent | requires isolated runtime + physical process validation |

## Bounded verification and engineering use

See [3300/4000 commissioning guide](../guides/3300-4000-linuxcnc-g64-p-q-cam-geometry-preflight-2026-11-02.md) and [minimal fixtures](../examples/4000_g64_q_164/README.md). Use an **isolated, physically disconnected** LinuxCNC simulation to compare canonical queued feed move endpoints, not just Axis preview. Do not dispatch hosted Actions. For precision contours, do not assume P alone limits deviation when a post sets a larger Q; review Q and source versions explicitly. For plasma and OpenPressBrake, this is CAD/CAM geometry research only; it does **not** authorize any machine-motion G0/G1, safety-channel, backgauge or tooling change.

**Promotion / next:** priority MEDIUM for an original-vs-control Task canonical trace and G17 arc threshold trace on qualified self-hosted compute; not a graduation blocker for already closed 1000/2000/3000 levels. First executable priority remains independent MOTION-144 if isolation available. No lab or blind-evaluation ledger change.

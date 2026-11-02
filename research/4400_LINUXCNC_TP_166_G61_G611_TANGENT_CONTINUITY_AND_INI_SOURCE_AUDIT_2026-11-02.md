# 4000-LC-TP-166 — G61 exact-path versus G61.1 exact-stop: tangent continuity is a planner/configuration decision

**2026-11-02 | 3100 mill, 3300 plasma, 3400 router, 3600 press-brake toolpath transfer | NON-GRADUATED.** SOURCE-CONFIRMED static (stable and development); DOC-CONFIRMED; upstream interpreter test **source** inspected; runtime velocity/position **NOT RUN**. This is ordinary LinuxCNC trajectory planning, not a personnel-safety function.

## Question, novelty, and predecessor reconciliation

**Question:** Can a CAM post or machine macro use `G61` as a command to *stop at each programmed vertex*? **No.** G61 means exact path, not mandatory zero velocity. With arc-blend optimization enabled, the trajectory planner can convert an eligible exact-path boundary to a tangent continuation. `G61.1` is the explicit exact-stop request. This is a distinct implementation-level explanation of the **tangent promotion and INI dependency**, not a rediscovery of G64 rounding.

Read [PATH-BLEND-01](4400_PATH_BLEND_01_LINUXCNC_2910_G64_G0_CLEARANCE_AND_STOP_MODE_SOURCE_AUDIT_2026-10-28.md) (already teaches G61 vs G61.1 and rapid clearance), [TP-30](4400_LINUXCNC_TP_30_G64_P_Q_NAIVECAM_CANONICAL_GEOMETRY_AND_IO_BOUNDARY_SOURCE_AUDIT_2026-10-31.md) (G64 P/Q coalescing and I/O), [G64-Q-164](4400_LINUXCNC_G64_Q_164_NAIVECAM_PREFILTER_GEOMETRY_AND_ARC_DOC_SOURCE_AUDIT_2026-11-02.md), full PROGRESS/LESSON mechanism scans (three predecessor hits). New delta: why exact-path may retain feed across a tangent joint, when it cannot, and why a static canonical test cannot prove motion stops.

## Exact source provenance and call chain

Stable LinuxCNC **v2.9.10** annotated-tag peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`:
1. [`src/emc/rs274ngc/interp_convert.cc`, `Interp::convert_control_mode`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc), blob `f01a359652d588d59c9e210fa441a99d2ee19598`: G61→`CANON_EXACT_PATH`, G61.1→`CANON_EXACT_STOP`, G64→`CANON_CONTINUOUS`; **control-mode change rejected while cutter radius compensation active**. Comment explains exact-path can avoid unnecessary stops.
2. [`src/emc/task/emccanon.cc`, `SET_MOTION_CONTROL_MODE`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`: flushes buffered segments, queues `EMC_TRAJ_SET_TERM_COND` with `EXACT` for G61, `STOP` for G61.1. **Do not conflate this canonical flush with a commanded physical stop.**
3. [`src/emc/task/taskintf.cc`, `emcTrajSetTermCond`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskintf.cc), blob `96a041d1feef8560f37159a2f18b109171f084c3`: direct condition passthrough via `EMCMOT_SET_TERM_COND`; [`motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/command.c), blob `0b79061d39be915bbea548b2c33bb794d31ab302`, calls `tpSetTermCond`.
4. [`src/emc/tp/tp.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tp/tp.c), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`: `tpSetTermCond` sets subsequent segment default; `tpAddLine` copies state, calls `tpHandleBlendArc` **only if** `emcmotConfig->arcBlendEnable`, then queues and optimizes. `tpHandleBlendArc` first calls `tpSetupTangent`. In `tpSetupTangent` (approx lines 1833–1940), **STOP is rejected**, but **EXACT is not**. Other gates: no ABC/UVW movement, `arcBlendOptDepth>=2`, tangent vectors computable, not near-antiparallel, and acceleration/kink test. On eligible continuation `tcSetTermCond(prev_tc,tc,TC_TERM_COND_TANGENT)` plus `tcSetKinkProperties` modifies the prior boundary to permit nonzero end velocity; it does not add a shortcut blend arc.
5. [`src/emc/tp/tc.c`, `tcSetupState`/`tcSetTermCond`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tp/tc.c), blob `d314a13f365cda67e673382f5c537a2ea625b4d2`: copies `tp->termCond` into each new TC and clears `blend_prev` for EXACT/STOP/TANGENT. `tpCheckBlendArcType` separately requires PARABOLIC; therefore a G61 tangent continuation is **not the same thing** as a G64 geometric corner-shortcut arc.
6. [`src/emc/ini/initraj.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/ini/initraj.cc), blob `9cae3421c6068635117976070e74ba486b23248a`: default `[TRAJ] ARC_BLEND_ENABLE=1`, `ARC_BLEND_OPTIMIZATION_DEPTH=50`, `ARC_BLEND_KINK_RATIO=0.1`; real INI and `ini.traj_arc_blend_enable` can affect behavior. With arc blending disabled, this specific `tpSetupTangent` path is skipped; equivalence to G61.1 for *all* planner details is **NOT proven**.
7. [Official v2.9.10 user concepts](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/user/user-concepts.adoc) blob `bbcd416eb806d7bb05a649c724291d00e0f4d4d5`: G61 visits the programmed point even if stopping is needed; G61.1 stops at every segment end. [`tests/interp/g6164/test.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g6164/test.ngc), blob `54ba8296d8e147095d8f0730a3bedd7dc1465487`, and [expected](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g6164/expected), blob `061d73ac742eb2886cc9a2c43bb964609ca6194a`, establish **canonical mode emissions**, not a servo-velocity oracle.

Development comparison pinned `67437d8865e431a9a33f74cee912dbf891d3b4c5`: `tp.c` blob `2b4024c9ab131f708cc22760300231878c9b0fdc` retains STOP-only `tpSetupTangent` rejection and `tpSetTermCond` semantics; `emccanon.cc` blob `5ad736c59e85495aa06573ebcad2d49d59145583` retains EXACT/STOP mapping, adds G64 R planner args; `interp_convert.cc` blob `379b21eaba65840ce4160e7ea70df60c12fad9ff` retains G61/G61.1 mapping. This is **source-scope stability**, not a runtime claim.

## Source-derived discriminators (not measured)

| Program/INI case | Prediction | Evidence boundary |
|---|---|---|
| A. G61, collinear XYZ G1 segments, arc blend enabled/depth≥2 | Eligible for tangent conversion, hence no *mandatory* stop at shared endpoint | SOURCE path; actual nonzero speed UNKNOWN until traced |
| B. G61.1, same segments | STOP blocks tangent conversion; exact-stop requested | SOURCE/DOC; servo trace NOT RUN |
| C. G61, 90° corner | No shortcut arc from exact mode; must respect exact programmed vertex, may decelerate to stop | SOURCE/DOC; actual velocity NOT RUN |
| D. G61, arc blend disabled | Tangent-promotion path bypassed | SOURCE; all other TP outcomes not assumed |
| E. G61/G61.1 issued while G41/G42 active | Interpreter rejects control-mode change | SOURCE; fixture NOT RUN |
| F. G64 P0 Q0 | Continuous mode without tolerance or naive-CAM; **not** exact path | Existing TP-30 predecessor |

**Failure of reasoning:** “G61 means an exact stop at each CAM lead-in/lead-out, tool-change approach, plasma pierce point or backgauge waypoint” silently confuses **point visitation** with **zero boundary velocity**. For process-critical dwell/settle, use a justified exact-stop or explicit wait/process handshake and inspect actual Task/motion status. Neither is a protective stop, nor proof of physical clearance.

## Reproducible disconnected experiment design

[Fixture README and three NGC programs](../examples/4000_g61_166/README.md) specify matched G61/G61.1/G64 cases. Freeze `v2.9.10`, a physically disconnected simulator, `[TRAJ] ARC_BLEND_ENABLE`, depth, servo period, max acceleration/velocity, program and HAL trace. Compare *same segment junction* commanded velocity and joint feedback, with a negative control (G61.1). Canonical `tests/interp/g6164` can confirm command identity, **not** velocity. No runner dispatch: current self-hosted runner isolation is not independently proven, and the allowlisted lab workflow does not admit arbitrary motion experiments. Hosted compute prohibited.

## Evidence, dependencies, and next work

- SOURCE-CONFIRMED: distinct interpreter/canonical/TP term conditions, tangent eligibility gates, INI defaults, development comparison.
- DOC-CONFIRMED: G61 exact path vs G61.1 exact stop.
- INFERENCE: eligible G61 collinear junction may carry nonzero velocity; the exact velocity and timing require disconnected TP telemetry.
- TEST-CONFIRMED: **none this lesson**; no LinuxCNC build/run, GUI, machine, or evaluator.
- UNKNOWN: effect of live INI pin changes on an already queued path, other planner implementation variants, physical following error and exact junction velocity.
- Dependencies: qualified physically disconnected `[self-hosted, openpressbrake]` compute + reviewed bounded job; independent safety gates remain unchanged. Do not reopen graduated levels or claim OpenPressBrake G0/G1 release.

**Decision:** add a narrow tangent-continuity source audit rather than another generic G64 or safety module. Preserve prior TP-30 and PATH-BLEND-01 conclusions and queue a discriminating simulator experiment only when allowed.

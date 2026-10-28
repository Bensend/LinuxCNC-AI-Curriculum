# 4400-PATH-BLEND-01 — G64, G0 corner clearance, and planned versus physical path
**2026-10-28 | SOURCE-CONFIRMED static v2.9.10 inspection; DOC-CONFIRMED upstream documentation; COMMUNITY-REPORTED field warning; NOT TESTED.**

## Question and novelty
Can a programmed Z-up, then XY rapid retreat be treated as a guaranteed orthogonal clearance path when G64 is active? **No.** The incremental mechanism is trajectory-planner corner blending of *rapid* segments; the earlier [G28/G30 source audit](4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md) established coordinate/waypoint selection, not the subsequent planner's geometric rounding. Canonical index, research plan, progress and research filenames were checked for G64/G61/trajectory-blend predecessors before treating this as a new source-depth branch.

## Pinned provenance and call path
- LinuxCNC annotated tag **v2.9.10**, peeled commit **`86cdca76fa2a36274c432caa21952b23c267989a`**. [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) blob `f01a359652d588d59c9e210fa441a99d2ee19598`: `Interp::convert_control_mode` maps G64 to `CANON_CONTINUOUS` with nonnegative P tolerance (otherwise 0); G61 to `CANON_EXACT_PATH`; G61.1 to `CANON_EXACT_STOP`. With G64, unspecified Q defaults to P when P supplied, else 0. The interpreter rejects a mode change with cutter compensation active.
- [`emccanon.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`: `SET_MOTION_CONTROL_MODE` first `flush_segments()`, converts mode to `EMC_TRAJ_SET_TERM_COND` (BLEND/EXACT/STOP), and appends it to the interpreter list. This is normal command sequencing, not a safety-rated stop.
- [`taskintf.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskintf.cc) blob `96a041d1feef8560f37159a2f18b109171f084c3`: `emcTrajSetTermCond` emits `EMCMOT_SET_TERM_COND`. [`motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/command.c) blob `0b79061d39be915bbea548b2c33bb794d31ab302`: that command invokes `tpSetTermCond` on coordinated TP.
- [`tp/tp.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tp/tp.c) blob `5768d6e6880569f72156ed9a761b5eee531c9fcf`: `tpSetTermCond` writes `tp->termCond` and `tp->tolerance`. `tpAddLine` calls `tcSetupState`, handles mode change and optional arc blending, then queues and optimizes segments. [`tp/tc.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/tp/tc.c) blob `d314a13f365cda67e673382f5c537a2ea625b4d2`: `tcSetupState` copies TP termination condition/tolerance to each segment. Planner blend logic limits velocity based on tolerance when positive. This is a *planned trajectory* condition, not measured servo following accuracy, collision geometry, or a physical safe state.
- Existing [`tests/interp/g6164/expected`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g6164/expected) blob `061d73ac742eb2886cc9a2c43bb964609ca6194a` includes canonical G64 continuous (0, 1), G61 exact-path and G61.1 exact-stop emissions. **Existing fixture only; not executed in this session.**

## Documentation and community comparison
- [Official v2.9.10 user concepts](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/user/user-concepts.adoc) blob `bbcd416eb806d7bb05a649c724291d00e0f4d4d5` explicitly says **rapid moves obey the current trajectory control**, G64 is default, **G64 P0 has the same effect as G64**, and untoleranced rapids can round corners substantially on low-acceleration machines. It warns about clearance.
- [Official G-code reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) blob `461c9eae52a9baf4b69895a6b84df250491953cf` distinguishes G61 exact path, G61.1 stop at every segment, and G64 P/Q path simplification. Q can merge nearly collinear linear segments; the G-code G0 reference says rapid corners can be rounded.
- [2018 LinuxCNC forum discussion](https://forum.linuxcnc.org/38-general-linuxcnc-questions/34963-rounding-corners) includes a reported gang-lathe rapid/stock-clearance collision concern with default blending. **COMMUNITY-REPORTED**, not a verified selected-machine incident or physical measurement.

## Failure path and authority boundary
1. Operator/CAM assumes `G0 Zsafe` followed by `G0 Xnext` means the physical tool reaches Zsafe before lateral travel.
2. In default G64, the planned corner may blend, initiating lateral displacement before reaching the exact programmed corner. In G64 without positive P, no specified geometric corner tolerance bounds the shortcut.
3. If clearance is marginal, **INFERENCE** collision is possible. No clearance, velocity, stop distance, actual deviation, or selected-machine geometry is known. Even positive P is *not* a safety-rated protective separation: axis following error, work offsets, tool envelope, fixture, and actual machine dynamics still matter.
4. G61 exact-path may slow/stop as necessary to visit programmed points; G61.1 plans exact stops at segment ends. Neither independently proves trusted homing, mechanical clearance, protective stopping, gravity holding, or guard access.

## Practical prevention / qualified witness
For normal non-safety process motion, explicitly declare desired path mode in the program preamble, use a verified clearance plane and **ordered Z-then-XY** moves, and consider G61.1 around clearance-sensitive segments where stops are process-appropriate. Restore a suitable contour mode only after the clearance phase. Review actual tool/fixture envelopes and path planning for the specific machine; never assert that G61.1 itself is a personnel safety function. Independent protective-device logic and physical energy removal/holding remain separate. The incremental physical witness is **qualified observed tool/fixture clearance under the selected mode, feed, acceleration, offsets and worst-case envelope**, plus independently validated protective stop/hold/guard functions; none has been run.

## Evidence ledger
| Claim | Class | Limits |
|---|---|---|
| G64→continuous/TP tolerance; G61/G61.1 distinct | SOURCE-CONFIRMED | Pinned 2.9.10 code only |
| G0 corners obey blending; P0 untoleranced | DOC-CONFIRMED | Pinned upstream docs |
| Field collision concern | COMMUNITY-REPORTED | No independent physical corroboration |
| Conditional shortcut collision on a given machine | INFERENCE | No geometry, execution or trace |
| OpenPressBrake usage / protective function | UNKNOWN | G0/G1 HOLD; physical witness NOT RUN |
| Runtime behavior in this session | TEST-CONFIRMED none | No compute or machine operation |

**Decision:** no simulation justified to rediscover the documented corner-mode behavior. Preserve this source result; request physical validation only during authorized qualified machine commissioning. No personnel-exposed hazardous operation.

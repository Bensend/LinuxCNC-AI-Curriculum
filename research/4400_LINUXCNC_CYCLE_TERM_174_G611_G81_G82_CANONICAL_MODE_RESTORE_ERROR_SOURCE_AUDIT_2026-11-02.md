# 4000-LC-CYCLE-174 — canned-cycle canonical termination-mode override and early-error restoration gap

**Date:** 2026-11-02. **Scope:** LinuxCNC core interpreter/Task, 3100 mill and 3400 router transfer; 4000 NON-GRADUATED. **Evidence:** SOURCE-CONFIRMED conditional branches; DOC-CONFIRMED public G61/G61.1/G64 and G81/G82 behavior; Task discard SOURCE-CONFIRMED; canonical trace/servo effects **NOT RUN / NOT TEST-CONFIRMED**.

## Question and predecessor check

When G61.1 exact-stop or G64 path blending is active, does a G81/G82 canned cycle retain the selected termination mode internally, and what happens if a cycle rejects missing parameters *after* changing canonical mode? Prior [TP-166](4400_LINUXCNC_TP_166_G61_G611_TANGENT_CONTINUITY_AND_INI_SOURCE_AUDIT_2026-11-02.md) established G61 exact-path tangent eligibility versus G61.1 STOP; [CYCLE-115](4400_LINUXCNC_CYCLE_115_G73_G83_PECK_CLEARANCE_VERSION_AND_R_OVERSHOOT_SOURCE_AUDIT_2026-11-01.md) covered peck-clearance, and existing upstream G81 tests cover G98/G99 planes. None establishes the **canned-cycle internal mode override and error unwind**. No graduated level is reopened.

## Pinned primary evidence

- Stable v2.9.10, peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`: [`interp_cycles.cc` lines 958–990, 978–1099](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L958-L1099), blob `3d3fd818ac1f36fd7a36620c654ad6b3677295be`. All six plane handlers have `GET_EXTERNAL_MOTION_CONTROL_MODE` → conditional `SET_MOTION_CONTROL_MODE(CANON_EXACT_PATH,0)` → switch/cycle → conditional restore. Stable occurrences: XY 978/1094, UV 1169/1283, YZ 1406/1520, VW 1594/1708, XZ 1839/1953, UW 2026/2155.
- Development pinned `67437d8865e431a9a33f74cee912dbf891d3b4c5`: [`interp_cycles.cc` lines 973–1094](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_cycles.cc#L973-L1094), blob `bbebc0d6ed872688c701a12f5a1467bff5f4fd94`, preserves all six override/restore pairs and P/Q validation *inside* the switched region. This is a two-revision source comparison, **not** a runtime equivalence claim.
- [Stable `interp_internal.hh` lines 869–912](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_internal.hh#L869-L912), blob `c400d66eb6e332b03caf700b4238e9fa91fc0799`: `CHKS` invokes `ERS`, which **returns `INTERP_ERROR` immediately**; it does not execute the bottom-of-function restore.
- [Stable `interp_convert.cc::convert_control_mode`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L1633-L1650), blob `f01a359652d588d59c9e210fa441a99d2ee19598`, maps G61.1 to `CANON_EXACT_STOP`, G61 to `CANON_EXACT_PATH`, G64 to `CANON_CONTINUOUS`.
- [Stable `emccanon.cc::SET_MOTION_CONTROL_MODE` lines 1193–1218](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc#L1193-L1218), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11`: flushes segments, changes canonical `canon.motionMode`, and appends `EMC_TRAJ_SET_TERM_COND` with EXACT/STOP/BLEND.
- [Stable Task `emctaskmain.cc` lines 541–551, 2268–2277](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc#L541-L551), blob `7292a172023a5b42b023447c2458cb766c93fc9b`: AUTO interpreter-error handling clears `interp_list` and calls abort cleanup; MDI interpreter-error handling clears list, aborts Task/IO/spindles and cleans up. [Development Task lines 592–602, 2410–2419](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/task/emctaskmain.cc#L592-L602), blob `049c640f1af1b21c18161d6c065ff6f3e35fd83b`, preserves the clearing/abort distinction. **A canonical command emitted during interpretation is not proof Task sent it to motion**.
- Official [G61/G61.1/G64](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L1703-L1738), [G81/G82](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2331-L2491) and [G98/G99](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2851-L2885) document external semantics, not the internal mode-switch or failed-block unwind.

## End-to-end source trace

1. Program `G61.1` sets both interpreter `settings->control_mode=CANON_EXACT_STOP` and canonical STOP. `G64 P0.1` instead establishes continuous/blend mode; G61 establishes exact-path mode.
2. On a **valid** G81/G82, `convert_cycle` dispatches `convert_cycle_xy`. If the current initial Z is **below** R, `STRAIGHT_TRAVERSE` to R is emitted **before** the temporary termination-mode switch. Otherwise no such preliminary traverse occurs.
3. The cycle saves the external canonical mode/tolerances, switches to `CANON_EXACT_PATH` unless already exact-path, emits canonical rapid/feed cycle motions via `CYCLE_MACRO` and `convert_cycle_g81/g82`, then restores the saved canonical mode/tolerance and naive-CAM tolerance on **successful completion**. Interpreter `settings->control_mode` is not itself changed by this temporary canonical switch.
4. On a **first G82 without P**, `CHKS((settings->motion_mode != G_82) && (block->p_number == -1.0), ...)` is evaluated **after** switching to exact-path (stable line 989; development line 984). `ERS` returns directly; the trailing restore is skipped. A first G83 without Q has the analogous branch (stable 1007; development 1002). Other post-switch errors exist, including G87 missing I/J/K, G86 missing P, and `CYCLE_MACRO` failures. The source establishes **an interpreter/canonical error-unwind gap**; persistence across Task abort/reinitialization is **UNKNOWN**.
5. In the full Task AUTO/MDI error path, `interp_list.clear()` and abort logic mean the intermediate canonical `SET_MOTION_CONTROL_MODE` or preliminary `STRAIGHT_TRAVERSE` cannot simply be equated with an accepted physical command. Queued commands from earlier blocks and machine state require a separate Task/motion trace.

## Frozen discriminators (predictions, not observations)

All programs set G21 G17 G90, F100, and initial Z explicitly. Use separate modal lines; no cutter compensation or hardware I/O.

| Case | Interpreter-source prediction | Unknown |
|---|---|---|
| A `G61.1; G81 ...` | Canonical STOP → EXACT → STOP around cycle; internal G81 motions tagged EXACT | TP junction velocity, physical stop |
| B `G64 P0.1; G81 ...` | BLEND → EXACT → BLEND; original tolerance restored | exact Task timing |
| C `G61; G81 ...` | Existing EXACT retained; no extra override/restore | unrelated planner behavior |
| D `G61.1; G82 ...` **P omitted**, start Z5 > R2 | STOP → EXACT → interpreter error; no trailing STOP in this function | standalone error print, post-abort canonical reset |
| E same invalid G82, start Z0 < R2 | preliminary canonical rapid to R **before** EXACT and missing-P error; Task error branch clears list | physical motion: **not established** |
| F valid `G61.1; G82 ... P0.1` | STOP → EXACT → STOP, with dwell | runtime timing |

**Counterfactual:** If Task always resets canonical state after an interpreter error, D/E do **not** demonstrate a persistent operational mode defect. They still establish an early-return source path and teach the crucial difference between canonical emission and Task acceptance. A single standalone `rs274 -g` trace cannot prove servo motion or machine safety.

## Existing upstream tests, executable next steps, and review guidance

Inspected [`tests/interp/g6164/test.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g6164/test.ngc) and [expected](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g6164/expected): mode-setting canonical lines only; no canned cycles. Inspected [`tests/interp/g81/g17/g98/g17-g98-g81.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g17/g98/g17-g98-g81.ngc) and [G99 fixture](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g17/g99/g17-g99-g81.ngc): retract geometry, not G61.1/G64 or missing-P unwind. These are **upstream test sources inspected, NOT tests executed here**.

[Six disconnected fixtures](../examples/4000_cycle_term_174/README.md) and [reproduction guide](../guides/3100-3400-4000-linuxcnc-canned-cycle-exact-stop-error-commissioning-2026-11-02.md) freeze the interpreter and Task distinctions. A prospective fix must (a) validate all feasible parameters **before** preliminary canonical movement/mode switch, (b) restore canonical mode on every remaining error return via a carefully scoped guard, (c) verify queued command order/Task abort, and (d) avoid changing successful G81/G82 behavior. **No patch has been applied or reviewed as a buildable fix.** RAII alone does not make previously emitted canonical motion transactional.

**Status:** SOURCE-CONFIRMED control flow and Task error handling; DOC-CONFIRMED public behavior; INFERENCE expected standalone mode sequence; TEST-CONFIRMED none; UNKNOWN physical/servo behavior and post-abort mode persistence. No LinuxCNC run/build, no machine, no evaluator, no Actions (hosted/self-hosted 0/0 min). Graduated levels and independent personnel-safety/OpenPressBrake G0/G1 HOLD unchanged.

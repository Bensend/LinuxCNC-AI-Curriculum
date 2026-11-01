# 2026-11-01 ~18:40Z — 4000-LC-ARC-129 next checkpoint
**LinuxCNC-first; NON-GRADUATED; 3100/3200/3300/3400 CAD/CAM transfer.**

## Durable work
- [ARC-129 pinned source/documentation audit](../research/4400_LINUXCNC_ARC_129_G901_G911_XZ_CENTER_WORD_DOC_SOURCE_FREECAD_HANDOFF_2026-11-01.md) establishes stable `86cdca76fa2a36274c432caa21952b23c267989a` and development `06864e23559e70463fc7112d5ce77138bcbc288c` G90.1 manual typo: G18 XZ says J/K, but both interpreters require I/K and reject J. `rs274ngc_pre.cc` initializes IJK incremental; `setup::setup()` constructor absolute is overwritten on initialization.
- [Practical CAM walkthrough](../guides/3100-3300-3400-4000-linuxcnc-g18-absolute-arc-center-cam-preflight-2026-11-01.md) distinguishes G90 endpoint mode from G90.1/G91.1 center mode; traces FreeCAD `24ea8589aa8676049f7fe53ca9d1d1c398c38d26` LinuxCNC post default G90 **without G91.1**, and base post IJK serialization without false duplicate-suppression claim.
- Two standalone [positive](../examples/4000_arc_center_mode/g18_center_mode_comparison.ngc) / [negative](../examples/4000_arc_center_mode/g18_documented_jk_negative.ngc) G18 interpreter fixtures; **NOT RUN**. Predicted A/B center X0 Z0 radius10; negative J0 K0 rejects J in XZ.
- Novelty: ARC-03 was radius-tolerance, CAM-59 was cutter comp, PLASMA-81 was QtPlasmaC modal rewrite. This is a distinct plane-center DOC/SOURCE contradiction and CAM modal ownership.
- No build, interpreter execution, FreeCAD export, simulator, physical machine, evaluator or Actions compute. Lab and feedback ledgers unchanged. 1000/2000/F02/3000 graduated levels CLOSED, independent safety and OpenPressBrake G0/G1 HOLD.

## Precise next unblocked work
1. If positively qualified physically disconnected `[self-hosted, openpressbrake]` runner is available, execute **only** A/B and J/K negative with pinned LinuxCNC; capture stdout/stderr, exit, canonical center, binary revision and authoritative job start/end. Then compare a real pinned FreeCAD Path.Command/export with configured preamble; do not assume IJK semantics.
2. Runner physical isolation/access remains UNKNOWN. Do not dispatch existing Actions workflows or use hosted fallback without qualification. If unavailable, rotate to a **distinct** LinuxCNC motion/HAL/INI/real machine config topic, not another G90.1 paper case.
3. Preserve all previous pending G10/ABSENC/TAP/G87/G81 etc runtime checks as NOT RUN. Inspect full PROGRESS and predecessor files before claiming novelty; follow source provenance, evaluator separation and current file readiness. Keep hourly task enabled.

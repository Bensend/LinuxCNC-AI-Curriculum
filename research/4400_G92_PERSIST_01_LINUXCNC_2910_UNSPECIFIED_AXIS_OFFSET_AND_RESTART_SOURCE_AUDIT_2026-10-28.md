# 4400-G92-PERSIST-01 — G92/G52 shared offsets, omitted axes, and persistence
**2026-10-28 | SOURCE-CONFIRMED v2.9.10 static inspection; DOC-CONFIRMED with an explicit internal documentation conflict; NOT TESTED.**

## Increment and question
The preceding [G28/G30 reference-path audit](4400_G28_G30_01_LINUXCNC_2910_PERSISTENT_RAPID_REFERENCE_AND_WAYPOINT_HAZARD_SOURCE_AUDIT_2026-10-28.md) establishes the hazards of saved rapid waypoints. This audit instead asks whether an operator can assume a partial G92 command clears every unmentioned axis offset, or that a program end clears the G92/G52 offset registers. **Neither assumption is generally supported by the pinned implementation.** No G92-specific 4400 predecessor was found in the full canonical index, research plan, progress or research filename inventory.

## Pinned source and observed static branches
- LinuxCNC v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`; [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `Interp::convert_axis_offsets`. Both G52 and G92 set shared applied state and call `SET_G92_OFFSET`, then write parameter registers **5211–5219**.
- **G92 with a flagged axis** updates that axis's `settings->axis_offset_*` using current coordinate, old offset and requested coordinate. **Unflagged axes have no assignment in that branch**, so previously established offsets are preserved by the source path. This is a static source conclusion, not a runtime test.
- G92.1 and G92.2 clear active offsets and `5210`; **G92.1 also zeros saved 5211–5219**, while G92.2 retains those saved values. G92.3 restores saved 5211–5219 and sets active 5210.
- In `Interp::convert_stop` for M2/M30, registers 5210–5219 are cleared **only when** `settings->disable_g92_persistence` is true. [`rs274ngc_pre.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/rs274ngc_pre.cc) reads `[RS274NGC] DISABLE_G92_PERSISTENCE` with default false; [`interp_setup.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_setup.cc) also initializes the flag false. Thus ordinary M2/M30 must not be assumed to erase saved offsets under the default configuration. Do not extrapolate to every abort/reset path without tracing it.

## Documentation discrepancy: preserve rather than silently resolve
- [G-code G92 reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) blob `461c9eae52a9baf4b69895a6b84df250491953cf` states that if an axis word is not used, its offset will be zero. For a **previously nonzero omitted axis**, the inspected `convert_axis_offsets` G92 branch instead leaves its offset unchanged. **DOC-CONFIRMED statement versus SOURCE-CONFIRMED implementation conflict.** The source is authoritative for this exact tagged implementation; a novel runtime regression could be justified if actual behavior is disputed, but no safety claim depends on assuming the omitted offset clears.
- [Official coordinate-system chapter](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/coordinates.adoc) documents G52/G92 shared registers, unexpected persistent offsets, the default persistence behavior and G53 as nonmodal machine-coordinate motion. It specifically warns offsets may be applied when an axis is homed. The G52 section says unmentioned axes retain their previous offsets, which is consistent with the shared-register implementation but does not by itself resolve the G92 wording conflict.
- [INI configuration reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-config.adoc) lists default `DISABLE_G92_PERSISTENCE=0`. This is configuration documentation, not proof of any installed OpenPressBrake setting.

## Adversarial process failure path
1. A setup program leaves a nonzero Z G52/G92 offset in the shared registers.
2. Another program issues only `G92 X...`, expecting Z to reset; **SOURCE-CONFIRMED** the Z branch is untouched, despite the conflicting single-page G92 prose.
3. A later ordinary absolute work-coordinate move can use the retained Z offset; **INFERENCE** a planned clearance height can be wrong. No actual machine geometry, physical travel, tool position, collision or servo behavior has been observed.
4. G53 bypasses work/local offsets for a single block **only if the machine-coordinate reference is trustworthy**; it is not proof of home/physical position, collision-free route, independent safety or gravity-load holding. M2/M30 alone is not an unconditional offset cleanup.

## Practical operator and reviewer contract
Show active G52/G92 offsets and `5210–5219` provenance in setup/diagnostics; include an explicit `G92.1` when the *process* requires clearing saved offsets (after checking whether any active workflow relies on them), and make work-coordinate validation a visible pre-run check. A short setup checklist is cheaper than diagnosing a hidden offset after a crash. Do not substitute any coordinate display for physical reference verification, independent guarding, safe motion, or qualified stop/hold. **Incremental witness:** selected configuration file, saved parameter state, reproducible coordinate display before/after controlled commands, independent homing trust and qualified physical clearance; all selected-machine evidence UNKNOWN/NOT RUN.

## Evidence ledger
| Proposition | Class |
|---|---|
| G92 unflagged axes retain previous offset in inspected branch | SOURCE-CONFIRMED |
| G92.1 clears saved offsets; G92.2 retains; G92.3 restores | SOURCE-CONFIRMED |
| Default persistence flag false; M2/M30 conditional clear | SOURCE-CONFIRMED / DOC-CONFIRMED |
| G92 single-page omitted-axis-zero statement | DOC-CONFIRMED; conflicts with inspected branch |
| Specific unexpected motion or collision | INFERENCE / NOT TESTED |
| Installed machine configuration, home, safe clearance | UNKNOWN |
| Executed lab / physical validation | TEST-CONFIRMED none |

**Safety boundary:** ordinary interpreter offsets, TP, HAL and FPGA remain normal control. G0/G1 HOLD; no personnel-exposed hazardous operation. No lab or hosted compute used.

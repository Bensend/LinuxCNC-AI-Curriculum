# 4000-LC-TAP-74 — G84 selected-spindle direction check uses stale spindle in UV/YZ planes
**2026-10-31 | SOURCE-CONFIRMED static; CONDITIONAL INFERENCE; TEST-CONFIRMED none | NON-GRADUATED**

## Why this is distinct
The previous [SPINDLE-64](4400_LINUXCNC_SPINDLE_64_M5_STOP_AND_PROBE_ATSPEED_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-31.md) covers M5 stop-to-feed behavior; this investigation concerns **which spindle's direction is validated** by G74/G84 canned cycles when a block contains `$-` spindle selection. Full PROGRESS novelty scan found no G84 source investigation. Official [G84 documentation](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2533-L2570) calls G84 floating-chuck tapping, explicitly **not synchronized motion**, and documents `$-` spindle selection.

## Stable and development source chain
Pinned LinuxCNC stable v2.9.10 peeled `86cdca76fa2a36274c432caa21952b23c267989a`, development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Both versions of [interp_cycles.cc stable](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc) and [development](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_cycles.cc) contain:
1. At the start of `Interp::convert_cycle_uv` (development ~1099) and `Interp::convert_cycle_yz` (development ~1335), local `int spindle = settings->active_spindle;` snapshots the previously active spindle.
2. In the G74/G84 case, `block->dollar_flag` validates the requested spindle index then assigns `settings->active_spindle = (int)block->dollar_number` (development ~1205–1208 UV; ~1442–1445 YZ).
3. **But** the call to `convert_cycle_g74_g84` supplies `settings->spindle_turning[spindle]` for direction, while its final `spindle` argument is `settings->active_spindle` (development ~1210–1213 UV; ~1447–1450 YZ). Those arguments can now refer to **different spindles**.
4. `convert_cycle_g74_g84` invokes `check_g74_g84_spindle(motion,direction)` before generating feed/reversal. For G84 it rejects STOPPED or counterclockwise; for G74 it rejects STOPPED or clockwise. Subsequent stop/reverse commands use the newly selected spindle argument.
5. Contrast: XY, VW, XZ, UW G74/G84 cases pass `settings->spindle_turning[settings->active_spindle]`, so this exact stale-snapshot mechanism is limited to UV and YZ in the inspected source.

## Falsifiable counterexamples (NOT RUN)
With active spindle initially 0, spindle0 STOPPED and spindle1 CLOCKWISE, `G19 G84 ... $1` can fail direction validation using spindle0 although spindle1 is clockwise. Conversely spindle0 CLOCKWISE and spindle1 STOPPED can pass that *direction check* and enqueue a G84 cycle aimed at spindle1; later Task/motion readiness may still reject or stop it. The actual parser/Task outcomes, G19 geometry and hardware consequences remain UNKNOWN. The source does not establish that physical tapping occurs with a stopped spindle.

## Candidate review-only fix
After parsing the `$-` selector, pass `settings->spindle_turning[settings->active_spindle]` consistently to `convert_cycle_g74_g84` in UV and YZ, as other planes do. Do **not** patch upstream or operate hardware without disconnected tests and upstream review.

## Evidence ledger and promotion
SOURCE-CONFIRMED: local spindle snapshot, selector update, mismatched arguments, direction-check branch, plane contrast in both pinned versions. DOC-CONFIRMED: G84 floating-chuck/no spindle synchronization. INFERENCE: conditional false rejection/acceptance. TEST-CONFIRMED none. Promote bounded interpreter test to 4000 verification (HIGH). Independent personnel safety and graduated levels unchanged.

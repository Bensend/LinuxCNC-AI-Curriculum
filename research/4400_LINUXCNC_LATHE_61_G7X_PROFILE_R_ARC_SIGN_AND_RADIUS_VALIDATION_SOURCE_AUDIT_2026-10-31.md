# LATHE-61 — G70/G71/G72 profile R-arc sign and radius-validation boundary

**2026-10-31 | 4000 LinuxCNC implementation / 3200 lathe transfer | SOURCE / DOC, NOT TESTED | NON-GRADUATED**

## Why this is new
The current curriculum already covers G76/G33 threading, G33.1 tapping, G95 feed, and G96 CSS. It does **not** cover the separate G70/G71/G72 interpreter-side profile geometry generator. This is not a re-graduation of 3200. The question is whether a lathe CAM post can rely on the same signed-R arc semantics in a G71 Q profile as in an ordinary G2/G3 block.

## Pinned evidence
- LinuxCNC **v2.9.10**, `src/emc/rs274ngc/interp_g7x.cc` blob `4baa447054d7e0b27a14824f0c798dfa521f3ee3`, `Interp::convert_g7x` and `motion_machine::circular_move`: [tagged source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_g7x.cc).
- LinuxCNC development **537cf2d765c96b6e75ae1db44e1dc0b9dba906a1**, same file blob `9056396be8644adb59af4bea961162a1e06bb970`: [pinned source](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_g7x.cc).
- Ordinary arc implementation: v2.9.10 `src/emc/rs274ngc/interp_arc.cc`, `Interp::arc_data_r`, and `interp_convert.cc` `Interp::convert_arc`: [tagged arc implementation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_arc.cc).
- Official [LinuxCNC 2.9 G71/G72 documentation](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html#gcode:g71-g72) states the profile is a Q subroutine with G0/G1/G2/G3 moves and explicitly warns that these cycles are fragile. The normal [G2/G3 documentation](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html#gcode:g2-g3) defines the sign of R for the large/small arc choice.

## Exact source trace
1. `interp_convert.cc::convert_motion` dispatches G70/G71/G71.1/G71.2/G72 variants to `convert_g7x`, not directly to `convert_arc`.
2. `convert_g7x` requires Q, enforces G18, disallows cutter compensation for G71/G72, temporarily switches distance/center modes to absolute, and scans the Q subroutine into `straight_segment`/`round_segment` objects.
3. For a profile G2/G3 with an R word, **both pinned revisions** calculate `center=(start+end)/2` and a perpendicular offset using `sqrt((r*r-norm(end-start)/4)/norm(end-start))`. The offset side depends on G2 versus G3 **but never on the sign of r**. Thus, with the same endpoints and arc direction, R+8 and R-8 construct the **same profile center** (SOURCE-CONFIRMED).
4. Ordinary `arc_data_r` explicitly chooses opposite center sides depending on `(move==G_2 && radius>0) || (move==G_3 && radius<0)`. It also rejects a radius smaller than half the chord, within a tolerance. This is a concrete cross-path semantic mismatch; it is not merely a documentation difference.
5. The G7x R path directly takes `sqrt` without an explicit half-chord guard. For a chord of 10 and R=4, the radicand is `(16-25)/100=-0.09`, so a normal IEEE-754 `sqrt` produces NaN. **The source establishes the invalid intermediate, not the final interpreter error, motion result, or machine response**.
6. Development adds `arc_data_ijk` validation to the **I/K** profile-arc branch, but its inspected `if (!block->r_flag)` guard excludes the R branch. Therefore the signed-R and undersized-R paths remain in the pinned development revision.
7. `motion_machine::circular_move` later emits generated contour arcs via `convert_arc` with computed I/K center coordinates. This downstream conversion does not recover the original sign of the Q-profile R word.

## Reproducible discriminators (all NOT RUN)
Use the existing upstream `nc_files/lathe_g70_71_demo.ngc` (v2.9.10 blob `9c61bb6db381387abbd6316c9d14e4326b7732ea`) as a syntax baseline. Work only in a disconnected simulation; no spindle, drive, or machine output. Define a Q profile with three nonzero segments, one G2 arc whose chord is 10 and radius magnitude 8; compare R8 and R-8 while keeping endpoints and direction identical. Collect (a) standalone interpreter/canonical generated geometry, (b) whether G71 accepts the resulting contour, and (c) a plain G2/G3 comparison outside G71. **Predeclare**: profile center is identical for signed R variants at the source-construction stage; ordinary arc center differs. A G71 acceptance or rejection verdict is not predeclared because monotonicity/offset checks may intervene.

For the invalid-radius discriminator, use a chord of 10 and R4 in a Q-profile arc; compare with a plain arc using R4. Capture exact error text, return code, and any emitted canonical moves. The NaN propagation and final handling are **UNKNOWN** pending executable evidence. Do not claim a physical move, a crash, or a usable toolpath.

## Engineering consequence and boundary
A CAM/postprocessor must **not** silently reuse negative-R major-arc semantics inside G7x Q profiles without verifying the installed LinuxCNC revision and actual canonical path. Prefer I/K geometry where the intended arc is expressible and independently validate the entire generated profile; even I/K requires version-specific verification. Any change to this source should first introduce a regression test contrasting positive/negative R and rejecting too-small radius *before* proposing a fix. The official 'fragile' warning is context, not proof of a specific failure.

## Evidence ledger / dependencies
| Proposition | Class | Status |
|---|---|---|
| Q-profile signed R is squared and sign not used in center selection | SOURCE-CONFIRMED | both pinned revisions |
| Normal G2/G3 signed R selects center side | SOURCE-CONFIRMED | v2.9.10 `arc_data_r` |
| Invalid R yields negative square-root argument | SOURCE-CONFIRMED mathematical path | downstream behavior UNKNOWN |
| Development I/K validation does not validate R path | SOURCE-CONFIRMED | pinned development |
| Actual G71 geometry and error outcome | UNKNOWN | qualified isolated test required |

**Promotion:** isolated canonical comparison is HIGH-value 4000 implementation evidence, but cannot change prior 3200 graduation. Physical cutting, controller timing and independent personnel safety remain out of scope. No independent test or evaluator score is claimed.

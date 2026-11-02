# 3100/3200/3300/3400/4000 — R-format arc and DXF post commissioning preflight (disconnected only)

**2026-11-02 | NON-GRADUATED | NOT EXECUTED.** Companion to [ARC-R-169](../research/4400_LINUXCNC_ARC_R_169_NEAR_SEMICIRCLE_ZERO_RADIUS_AND_REVERSED_MAJOR_DXF_POST_SOURCE_AUDIT_2026-11-02.md). Applies to generic mill/router/plasma posts and G18 lathe arc preflight; **not a press-brake machine program**. Never run example NC on a machine; no independent personnel-safety gate is changed.

## Source-to-post contract
1. From CAD/DXF, retain entity ID, original WCS start/end/center/radius/sweep, extrusion/OCS and transform provenance. A circle after nonuniform scaling is not an R-format circle. Distinguish a *forward* CCW DXF ARC from its **reversed traversal**; don't infer major-arc direction from a cross-product sign alone.
2. Before formatting G-code, choose G17/G18/G19, G20/G21, G90/G91 and G90.1/G91.1 explicitly; never assume a post's implicit startup state. For R format, require finite `R`, `abs(R)>0`, noncoincident endpoints and **`2*abs(R) >= chord`** after rounding to emitted precision. This conservative preflight is intentionally stricter than LinuxCNC's `RADIUS_TOLERANCE_MM=0.00127` feasibility slack. Keep start/end geometry and intended sweep; R sign controls major/minor, G2/G3 controls CW/CCW.
3. Compare the reconstructed R-center and sweep against the source CAD geometry, **not just interpreter success**. A wrong G3 R-1 can be syntactically valid but describe a different circle. Near-180°/near-360° geometry is numerically sensitive; prefer IJK center format where it preserves source geometry and validate its **separate** ARC-03 tolerance.
4. PathForge pinned `f3574ec` is a **research fixture**, not an approved production post: it also emits `G04 X` where LinuxCNC G4 requires P and can skip unsupported DXF types. Use the isolated `write_arc_entity` unit regression to avoid conflating those issues. The original two-entity LINE+ARC fixture is for a disposable disconnected post test, not physical cutting.

## Frozen source-only test matrix
| Case | Program/fixture | Predicted interpreter/post result | Evidence |
|---|---|---|---|
| R positive | G2 (0,0)→(10,0), R+6 | center (5,-sqrt(11)), minor clockwise | source/numeric, NOT RUN |
| R negative | G2 same endpoints, R-6 | center (5,+sqrt(11)), major clockwise | source/numeric, NOT RUN |
| Near semicircle | G2 same endpoints, R4.999 | source clamps to center (5,0), no R-too-small rejection | source/numeric, NOT RUN |
| Just outside slack | G2 same endpoints, R4.998 | radius-too-small rejection | source/numeric, NOT RUN |
| R0 tiny chord | G2 (0,0)→(0.001,0), R0 | first guard bypassed, division by zero path; final runtime UNKNOWN | source/numeric, NOT RUN |
| PathForge forward major | ARC center0 radius1 0°→270°, natural endpoints | G3 R-1 (correct forward) | source/numeric, NOT RUN |
| PathForge reversed major | same ARC reversed by preceding LINE (-1,-1)→(0,-1) | current writer G3 R-1; expected G2 R-1 | source/numeric, NOT RUN |
| PathForge reversed minor | ARC center0 radius1 0°→90° reversed | current writer G2 R+1 (correct reverse) | source/numeric, NOT RUN |

## Review-only reproducible artifacts
- [`test_pathforge_arc_direction_review_only.py`](../examples/4000_arc_r_169/test_pathforge_arc_direction_review_only.py) calls the pinned public writer with four minimal fake ARC objects; expected G2/G3/R are predeclared. It is **not** a LinuxCNC integration test and was not executed.
- [`reversed_major_correct_g2.ngc`](../examples/4000_arc_r_169/reversed_major_correct_g2.ngc) and [`reversed_major_wrong_g3.ngc`](../examples/4000_arc_r_169/reversed_major_wrong_g3.ngc) are two isolated, otherwise identical interpreter inputs with G21/G17/G90/G94/F100 and no process M-codes. At start (0,-1), end (1,0), R-1, predict centers (0,0) versus (1,-1). Do not compare only success/failure; capture actual `ARC_FEED` center/rotation in a disconnected `rs274 -g` canonical trace. **NOT RUN**.
- Use upstream LinuxCNC [bad interpreter test harness](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/bad/test) as a style reference, not as evidence that it already covers R0. If running a new case later, preserve interpreter version, INI, locale, exit, stdout/stderr, canonical output, and exact job timestamps. For R0 use a disposable interpreter/sanitizer, not the motion-controller or hardware.

## Release gates
**No source-only pass is a production-post pass.** Before trusting any generated NC, require full DXF entity coverage, source→NC geometry manifest, modal-state and arc-center comparison, process-specific post validation, independent motion/limit simulation, and machine-specific qualified commissioning. Independent personnel safety retains authority. Runner isolation for `[self-hosted, openpressbrake]` remains unverified, so all executable cases are pending.

## Integration fixture extension
The review-only pytest also includes a **builder-level DXF fixture**, not merely a direct writer call. It creates an in-memory R2010 LINE+270° ARC, invokes `GcodeBuilder.build`, checks that both entities are present in one connected component, and freezes the reversed-major-arc NC command. This catches a future change in optimizer ordering as well as writer direction. **NOT RUN.** A separate small-feature preflight should reject cases where two-decimal endpoint normalization collapses a genuine ARC to identical start/end, even when output precision is three decimals.

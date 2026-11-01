# 4000 — G5.2/G5.3 NURBS-to-CAM handoff and control-point preflight
**2026-11-01 | LinuxCNC-first implementation exercise | NON-GRADUATED; all runtime checks NOT RUN.**

## Purpose and prerequisite
For open-source CAD/CAM, DXF contour conversion and 3100 mill / 3300 plasma / 3400 router posts, distinguish **a NURBS definition accepted by the interpreter** from **the line/arc queue actually sent to motion**. Start with [NURBS-109](../research/4400_LINUXCNC_NURBS_109_G52_DEFAULT_WEIGHT_P_SENTINEL_SOURCE_DOC_AUDIT_2026-11-01.md), [NURBS-110](../research/4400_LINUXCNC_NURBS_110_BIARC_NONXY_FALLBACK_AND_SILENT_SKIP_SOURCE_AUDIT_2026-11-01.md), and [SPLINE-69](../research/4400_LINUXCNC_SPLINE_69_G93_F_PRESENT_BUT_NOT_APPLIED_G5_SOURCE_AUDIT_2026-10-31.md). The official [G5.2/G5.3 reference](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc#L619) labels the feature experimental. Do not conflate G5.2/G5.3 weighted NURBS with G5/G5.1 splines or G6.2 experimental extensions.

## Source-to-motion map
`G-code block -> init_block (P absent=-1) -> convert_nurbs (implicit first point; weighted control-point vector) -> G5.3 NURBS_G5_FEED -> sampled biarc -> ARC_FEED/STRAIGHT_FEED -> Task/motion`. In parallel `gcodemodule` generates a **different, line-sampled preview**. The 4000 skill is to inspect both consumers and identify when preview cannot certify the canonical queue.

## Postprocessor input contract
1. Normalize DXF units, transforms, arc handedness and contour winding **before** postprocessing. Treat any NURBS control-point weights as dimensionless; **do not** convert P with drawing length units.
2. Explicitly select G21/G20, G90, G17 and G94 with a known positive F. Never assume G93 block F will be applied to G5/G5.1 ([SPLINE-69](../research/4400_LINUXCNC_SPLINE_69_G93_F_PRESENT_BUT_NOT_APPLIED_G5_SOURCE_AUDIT_2026-10-31.md)).
3. Emit `G5.2 P1 L3` as a P-only opening line if using the current tool position as the implicit first point; give **P>0 explicitly on every following X/Y point**. If the opening G5.2 line contains X/Y, it too needs P>0. Check number of points >= order before G5.3.
4. For now, require G17 XY for G5.2/G5.3 until target-version non-XY canonical behavior is independently verified. Do not change units, plane, offsets or cutter compensation inside a control-point block.
5. A preview pass is **not** an acceptance gate: compare canonical endpoints and arc/line commands to a geometric reference. Preserve tolerances and actual sampled output rather than asserting exact NURBS interpolation.
6. For plasma, prefer an externally offset G40 contour when QtPlasmaC's hole/overcut features are required; see [plasma kerf handoff](3300-linuxcnc-plasma-kerf-compensation-units-cam-post-handoff-2026-11-01.md). This is optional integration research, not a compulsory CAD/CAM build.

## Read-only source exercise (no LinuxCNC runtime required)
Locate `init_block` and `convert_nurbs` in both pinned revisions. Predict weights for the first coordinate-bearing block with and without P; then trace the conditional positive-weight check on a later block. In development inspect `NURBS_G5_FEED`, `biarc`, `arc`, and the Python `gcodemodule` implementation; explain why a non-XY fallback and a return-0 approximation are different failure modes. Record line anchors and the **exact** version before teaching any conclusion.

## Minimal acceptance inputs — disconnected, NOT RUN
**Case A, explicit weights, reference control point path**
```ngc
G21 G90 G17 G94 F100
G0 X0 Y0
G5.2 P1 L3
X0 Y1 P1
X2 Y2 P1
X2 Y0 P1
G5.3
M2
```
**Case B, opening X/Y omits P:** replace the opening and first point with `G5.2 X0 Y1` and retain the other two weighted points. Predict first explicit weight -1, not default 1; record acceptance and canonical behavior separately.

**Case C, later X/Y omits P:** use Case A but change `X0 Y1 P1` to `X0 Y1`. Predict a positive-weight validation error; capture exact exit/diagnostic.

**Case D, plane and fallback:** use the same geometry in G19 YZ with X held fixed. Do not assert a fallback will occur naturally. Instrument canonical `biarc` and check which axes any fallback linear command addresses; compare the G17 reference and preview.

**Case E, skipped biarc:** isolate an input causing a `biarc` return 0 and record whether any canonical command is emitted for that interval. Do not classify a machine failure from a source-only branch.

**Case F, geometry consumer comparison:** compare the Python preview's 15 samples/control point with canonical's four biarc intervals/control point. Preserve each actual path; no claim of equal interpolation error.

**Case G, version matrix:** stable v2.9.10 versus development `24e84c4506b41634240f7087f0295e361a954886` for P omissions and supported plane mapping. Distinguish parser acceptance, canonical output, Task simulation and physical machine behavior.

All cases are **NOT RUN**. For each executable case freeze revision, source patch, G-code, command, exit code, stdout/stderr, canonical trace, measured job start/end/runtime, and a PASS/FAIL/HARNESS-INVALID decision. Only use a positively qualified, disconnected `[self-hosted, openpressbrake]` runner. **Never use GitHub-hosted runners or a physical machine** for these investigations.

## Handoff and uncertainty
A fresh engineer should be able to answer: why can a documented P1 default still yield a -1 stored weight? why can a correct YZ preview disagree with a canonical fallback? why is the return value of `biarc` significant? These are **source-competency questions**, not an independent blind exam. No graduated level is reopened, no evaluator results are fabricated, and independent personnel-safety gates remain unchanged.

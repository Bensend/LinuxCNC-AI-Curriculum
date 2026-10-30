# 4000-LC-ARC-03 — LinuxCNC G2/G3 center-radius tolerance: INI→interpreter and documented-default conflict
**2026-10-30 | LinuxCNC stable v2.9.10 and pinned development | SOURCE-CONFIRMED + DOC-CONFIRMED conflict | no runtime test | NON-GRADUATED**

## Bounded diagnostic question and novelty
When a DXF/CAM post emits a G2/G3 I/J arc with slightly different start/end radii, **which tolerance does LinuxCNC actually apply, and is the documented default the compiled default?** The preceding [CAM post trace](4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md) established that nonuniform INSERT geometry can produce unequal radii. This follow-up traces **LinuxCNC itself** from INI/default setup to the interpreter's rejection condition. A direct full-PROGRESS predecessor scan found no earlier `CENTER_ARC_RADIUS_TOLERANCE` investigation; this is a new source/documentation discrepancy, not a repeated G64 overview.

## Immutable source and official documentation
- Stable LinuxCNC **v2.9.10** commit `86cdca76fa2a36274c432caa21952b23c267989a`: [`src/emc/rs274ngc/interp_internal.hh`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_internal.hh) ~68–90, [`rs274ngc_pre.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/rs274ngc_pre.cc) ~855–859, 1037–1060, [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) ~563–618, [`interp_arc.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_arc.cc) ~257–307, [`docs/src/config/ini-config.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-config.adoc) ~519–520.
- Development commit `24e84c4506b41634240f7087f0295e361a954886`: [`interp_internal.hh`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_internal.hh) ~72–95, [`rs274ngc_pre.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/rs274ngc_pre.cc) ~875–877, 1070–1096, [`interp_arc.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_arc.cc) ~280–302, [`ini-config.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/config/ini-config.adoc) ~599–600.
- [Official LinuxCNC 2.9 G2/G3 documentation](https://www.linuxcnc.org/docs/2.9/html/gcode/g-code.html) explains IJK center format, rounding sensitivity, and radius-to-start versus radius-to-end rejection. This is intended/public behavior, not a test of the pinned implementation.

## Actual initialization → conversion path
1. **Compile-time defaults:** `interp_internal.hh` defines `CENTER_ARC_RADIUS_TOLERANCE_INCH = 2*0.001*sqrt(2)`, `CENTER_ARC_RADIUS_TOLERANCE_MM = 2*0.01*sqrt(2)`, minimum accepted INI values 0.00004 inch / 0.001 mm, and `SPIRAL_RELATIVE_TOLERANCE=0.001`. The header comment explicitly says these are default center-radius tolerances for rounded coordinates.
2. **Interpreter setup:** `rs274ngc_pre.cc` assigns those compile-time values to `_setup.center_arc_radius_tolerance_inch/mm`. If an INI is present, it reads `[RS274NGC]CENTER_ARC_RADIUS_TOLERANCE_INCH` and `_MM` within [minimum, compiled default] bounds. Stable uses `IniFile::Find`; development uses `isSet`/`findReal`. Both inspected revisions preserve the **same default constants and upper bounds**.
3. **Arc conversion:** `convert_arc` selects `convert_arc2` for no cutter compensation. `convert_arc2` selects the current unit's `center_arc_radius_tolerance`, passes it and `SPIRAL_RELATIVE_TOLERANCE` into `arc_data_ijk` when the block uses IJK rather than R.
4. **Reject before canonical motion:** `arc_data_ijk` calculates `r_start=hypot(center-start)`, `r_end=hypot(center-end)`, `abs_err=|r_start-r_end|`, `rel_err=abs_err/max(r_start,r_end)`. It rejects when `abs_err > 100*T` **OR** `(rel_err > 0.001 AND abs_err > T)`, where `T` is the selected unit's center-radius tolerance. Only after successful conversion does `convert_arc2` call `ARC_FEED`. The actual acceptance condition is **not** simply `abs_err <= T` and is not a universal fixed 0.005-mm threshold.

## Pinned same-revision DOC/SOURCE discrepancy
| Quantity | Compiled source default | Pinned official INI documentation's stated default | Classification |
|---|---:|---:|---|
| Center-arc tolerance, inch | `2*0.001*sqrt(2)` ≈ **0.002828427 in** | **0.00005 in** | SOURCE/DOC conflict |
| Center-arc tolerance, mm | `2*0.01*sqrt(2)` ≈ **0.028284271 mm** | **0.00127 mm** | SOURCE/DOC conflict |
| Minimum permitted INI override | **0.00004 in / 0.001 mm** | not established from the cited two lines | SOURCE-CONFIRMED |
| Relative mismatch condition | **0.001 (0.1%)** plus absolute terms | not established by those INI-default lines | SOURCE-CONFIRMED |

The discrepancy persists in **both inspected stable and development pins**. Interestingly the docs' inch default 0.00005 matches the distinct `RADIUS_TOLERANCE_INCH` source constant for the *minimum radius* of radius-format arcs; 0.00127 mm is 0.00005 inch ×25.4. **Possible documentation conflation is INFERENCE, not a verified historical cause.** Do not silently pick the more conservative documentation number as the actual running default or claim a software bug from the discrepancy alone.

## Worked diagnostic discriminator (static arithmetic, NOT RUN)
For an illustrative center-format arc with `r_start=10.000 mm`, `r_end=10.020 mm`, `abs_err=0.020 mm`, `rel_err≈0.001996` (0.1996%). With **compiled default** `T≈0.028284 mm`, neither `abs_err>100*T` nor `abs_err>T` is true, so the pinned source's radius-difference check **does not reject this mismatch**. If an INI explicitly sets `T=0.00127 mm`, the same code's second condition is true and it **does reject** (assuming other validation passes). This is a **source-derived conditional prediction**, not TEST-CONFIRMED output. The previous CAM audit's 2:1 ellipse-to-circle example has a far larger mismatch and would fail this check at the compiled default.

## Practical LinuxCNC debugging sequence
1. Pin LinuxCNC binary/source revision, record G20/G21, G17/G18/G19, G90.1/G91.1 and the exact NC arc start, end, I/J/K and feed.
2. Inspect the **actual active INI** `[RS274NGC]` center-radius overrides; do not assume the prose default. Inspect the matching source's `interp_internal.hh` constants and `rs274ngc_pre.cc` validation.
3. Calculate start/end radius and the two-part error condition. If a CAM post emits nonuniformly transformed circles, **fix/reject geometry**; do not widen arc tolerance to make an ellipse masquerade as a circle.
4. Distinguish a **post-time** chord substitution (DXF2GCODE `max_arc_radius`) from an **interpreter** arc rejection and a **G64 Q** geometry simplification. They occur at different boundaries.
5. Verify the corrected NC only in an isolated, disconnected software environment if a genuinely unresolved runtime question remains; no physical machine operation is justified by this audit.

## Evidence ledger and next
| Proposition | Class | Limit |
|---|---|---|
| Stable and development initialize center-radius tolerances to 2*rounding-step*sqrt2 | SOURCE-CONFIRMED | Exact two pins; no runtime |
| INI override bounded by min and compiled max | SOURCE-CONFIRMED | Exact two pins; invalid INI runtime behavior not tested |
| `arc_data_ijk` rejects via absolute+relative two-part condition before `ARC_FEED` | SOURCE-CONFIRMED | Exact two pins |
| Official INI docs list smaller defaults | DOC-CONFIRMED | Same-revision conflict unresolved |
| Documentation accidentally describes minimum R-arc radius instead | INFERENCE | Historical reason UNKNOWN |
| Numeric example's branch prediction | INFERENCE from source | No executed interpreter/NC fixture |
| Actual selected-machine tolerance, output or cut accuracy | UNKNOWN | Requires exact configuration and independent evidence |

**Next question:** Inspect upstream issue/commit history for the INI-default documentation mismatch and decide whether a **documentation-only correction** is warranted for stable/development. Avoid submitting a patch without maintainer/version context. Separately continue the current maintained CAM comparison. Neither task requires GitHub Actions compute. No G0/G1 or independent evaluator gate is changed.

## Second same-tag discrepancy: public G2/G3 rejection thresholds
The pinned stable [`docs/src/gcode/g-code.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) ~370–371 states an arc error for radius difference greater than **0.05 inch / 0.5 mm**, or exceeding both **0.0005 inch / 0.005 mm** and **0.1% of radius**. But the inspected compiled-default source uses `abs_err > 100*T || (rel_err > 0.001 && abs_err > T)` with `T=0.002828427 in / 0.028284271 mm`, yielding nominal absolute terms **0.282843 in / 2.828427 mm** and **0.002828 in / 0.028284 mm** before INI overrides. Thus the G-code prose is also **DOC-CONFIRMED as written but inconsistent with the pinned source default**, and cannot express the configurable INI tolerance. This is not evidence that all installations accept every arc below those limits: radius minimum, modal state, cutter compensation and other checks remain separate. Development [`g-code.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc) retains the same prose. A targeted GitHub issue search for `CENTER_ARC_RADIUS_TOLERANCE` returned no matching issue at inspection; that negative search is **not exhaustive upstream history**. A maintainer-facing correction should update **both** INI defaults and the G2/G3 prose and explicitly describe INI configurability, rather than silently changing interpreter behavior.

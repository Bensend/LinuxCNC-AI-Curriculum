# 4000-LC-NURBS-109 — G5.2 documented default P1 versus the parser's -1 sentinel
**2026-11-01 | LinuxCNC interpreter / CAM-post interface | NON-GRADUATED | SOURCE-CONFIRMED conditional, DOC/SOURCE-CONFLICT, TEST-CONFIRMED none.**

## Scope, predecessor and pinned sources
The previous [SPLINE-69](4400_LINUXCNC_SPLINE_69_G93_F_PRESENT_BUT_NOT_APPLIED_G5_SOURCE_AUDIT_2026-10-31.md) concerns **G5/G5.1 inverse-time feed**, not G5.2/G5.3 weighted control points. A direct scan of current `PROGRESS.md` and `LESSON_LOG.md` found no G5.2/G5.3 mechanism; this is a **new causal input-validation mechanism**, not a rebranded G93 audit.

- Stable LinuxCNC **v2.9.10**: [`init_block`, `p_number=-1`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_internal.cc#L294); [`convert_nurbs` and weight checks](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L140).
- Development **24e84c4506b41634240f7087f0295e361a954886**: [`init_block`, `p_number=-1`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_internal.cc#L300); [`convert_nurbs` G5.2 control-point handling](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L170).
- Both official tagged [G5.2/G5.3 documentation sections](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc#L619) state **"The default weight if P is unspecified is 1"**; G5.2/G5.3 is explicitly labeled experimental and not fully tested. Stable [same-tag documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/g-code.adoc#L631).

## End-to-end source trace
1. Each new G-code block starts with `block->p_number=-1.0` and `p_flag=false` in `init_block`. There is no automatic P1 substitution at this point.
2. On the **first G5.2 block**, the control-point vector is empty. The positive-P rejection is guarded by **vector already nonempty**, so `G5.2 X0 Y1` with no P is not rejected by that check.
3. `convert_nurbs` first appends the **implicit starting control point**, with weight 1 unless an initial P-only block supplies another positive weight.
4. If that same first G5.2 block also has X/Y, it then appends an **explicit** point with `CP.W=block->p_number` (stable) / `CP_G5.NURBS_W=block->p_number` (development), thus **-1** when P was omitted. See [stable assignment](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L166) and [development assignment](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L235).
5. On a **later** X/Y point, the vector is nonempty. Omitting P again leaves -1 and now trips `Must specify positive weight P for every Control Point`. The official blanket default-P1 statement does not describe either behavior.

### Distinguishing predictions — NOT RUN
```ngc
G21 G90 G17 G94 F100
G0 X0 Y0
G5.2 X0 Y1          (first explicit point: no P)
X2 Y2 P1
X2 Y0 P1
G5.3
M2
```
**SOURCE PREDICTION:** the first explicit point enters the NURBS control-point list with **weight -1**, despite documented default 1. Subsequent numerical curve generation, acceptance and final path are **UNKNOWN** until instrumented; do not infer a valid cut or guaranteed crash.

```ngc
G21 G90 G17 G94 F100
G0 X0 Y0
G5.2 P1 L3
X0 Y1                (later explicit point: no P)
X2 Y2 P1
X2 Y0 P1
G5.3
M2
```
**SOURCE PREDICTION:** the second block's missing P is rejected by the positive-weight check. Exact interpreter exit/diagnostic requires runtime evidence.

## Practical contract / falsification
A CAM post should emit **positive explicit P on every control-point line**, including the opening block if it carries coordinates; emit an explicit initial P-only block when an initial weight is required. Do not rely on documentation's P1 default. A disconnected, pinned-version standalone interpreter with a trace at `convert_nurbs` must record vector size/weights, parser exit, diagnostic and canonical commands. A trace showing both variants default to P1 would falsify this reading and trigger a source-path correction.

**Evidence boundary:** Source plus tagged documentation only; no interpreter, simulator, compiled test, machine motion, independent evaluator or Actions job. Neither an upstream defect report nor a safety verdict is claimed. Independent personnel-safety authority unchanged.

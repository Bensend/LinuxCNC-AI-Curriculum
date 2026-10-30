# 4000 practical handoff — DXF geometry → nesting → CAM → LinuxCNC NC acceptance
**2026-10-30 | source-based implementation checklist | NOT a validated post or machine procedure**

This guide accompanies [4000-LC-CAM-02](../research/4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md), the [ezdxf geometry source audit](../research/4400_DXF_EZDXF_01_BULGE_INSERT_NONUNIFORM_MINSERT_SOURCE_AUDIT_2026-10-30.md), and [LinuxCNC G64 Q study](../research/4400_LINUXCNC_G64_Q_NAIVECAM_MULTI_TURN_DXF_POST_SOURCE_AUDIT_2026-10-30.md). It is **not** a product build, executable test, proof of machine accuracy, or release to cut.

## Preserve four separate artifacts
1. **Source manifest:** original DXF hash, units, layer, entity handle, INSERT/MINSERT instance path, extrusion/OCS, scale/rotation/mirror and original curve/winding.
2. **Canonical geometry:** normalized world-space LINE/ARC/ELLIPSE/curve or explicitly tolerance-bounded polyline, holes/islands and bend lines classified separately, source IDs mapped to every contour.
3. **CAM/nesting manifest:** part placement transform, contour direction, kerf/offset, lead-in/out, cut order, material, machine profile, post revision, approximation/error budget and all rejected entities.
4. **NC audit:** generated G-code hash, modal G17/G20/G21/G90/G91.1/G64 state, G2/G3 center-radius consistency, post tessellation/chord substitutions, feature-to-NC line mapping, and machine configuration/version. NC comments or `Shape.nr` alone are not a stable DXF handle.

## Required geometry decisions before generating G-code
| Input | Accept only if | Otherwise |
|---|---|---|
| LWPOLYLINE bulge | Previous vertex controls outgoing edge; final vertex controls closed edge; sign/traversal retained | Reject or fix importer; do not connect vertices with chords silently |
| ELLIPSE | Native representation or explicit bounded approximation with independent maximum-deviation check | Reject; three interior samples per interval are not a universal global error proof |
| Nonuniform INSERT of circular geometry | Converted to true ellipse or bounded approximation, including block base point and OCS | Reject; never emit a circular G2/G3 for an elliptical contour |
| MINSERT / nested INSERT | Every row/column and transform resolved with unique provenance | Reject unexpanded instances; never assume a single INSERT is the whole array |
| Unsupported DXF entities/XCLIP | Explicitly handled or declared excluded with review | Do not treat an INFO log line or missing shape as an accepted cut |
| Post radius/precision limits | Check every curve emitted as G2/G3 or G1; validate chord error and rounding | Reject silent large-radius-to-G1 substitutions |
| Plasma material handoff | Machine-specific QtPlasmaC post explicitly supplies/validates M190/M66 material sequence and checks status | Do not assume a mill-oriented M3/M8 template is a QtPlasmaC post |
| Press-brake bend lines | Keep bend/mark/cut feature types and dimensions; independently solve tooling, bend sequence and backgauge | Do not equate a nested 2D contour with a valid bend program |

## Static source-based discriminator (not a captured runtime test)
A unit quarter-circle at center (0,0), start (1,0), end (0,1) becomes an **ellipse** under X-scale 2, Y-scale 1. If a post emits a center-format circular arc from (2,0) to (0,1) with center (0,0), the start radius is 2 and end radius is 1. That is not a circular arc. In LinuxCNC v2.9.10 `convert_arc2 → arc_data_ijk` checks the mismatch before `ARC_FEED`. See [official G2/G3 rules](https://www.linuxcnc.org/docs/2.9/html/gcode/g-code.html). This is mathematical/source reasoning; actual NC output and interpreter result were **not executed**.

## Minimal bounded future acceptance fixture (only if needed)
Freeze one DXF with (a) closed final-vertex bulge, (b) clockwise bulge, (c) a direct ELLIPSE, (d) a rotated uniform INSERT, (e) a nonuniform INSERT of an ARC, and (f) MINSERT. Predeclare expected canonical geometry and source IDs. Separately compare import output, nest placement, post G-code, and a **disconnected** LinuxCNC interpreter-only read; record deviation/rounding and all rejects. Avoid a physical machine, active outputs or assumed safe panel PC. No workflow should be dispatched until the local `[self-hosted, openpressbrake]` runner is actually accessible and **physical isolation independently established**. Never fall back to hosted runners.

**Boundary:** G-code parsing, ordinary LinuxCNC/HAL/FPGA controls, and a valid toolpath are not independent personnel-safety functions. Existing OpenPressBrake G0/G1 physical gates remain HOLD.

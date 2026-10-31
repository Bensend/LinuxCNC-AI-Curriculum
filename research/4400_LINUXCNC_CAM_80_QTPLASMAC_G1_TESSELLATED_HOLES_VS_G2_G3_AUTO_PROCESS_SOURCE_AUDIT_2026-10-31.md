# 4000-LC-CAM-80 — LinuxCNC QtPlasmaC automatic small-hole process is arc-command dependent

**2026-10-31 | LinuxCNC-first 3300 plasma CAM/nesting integration | NON-GRADUATED.** This is a new **cross-tool integration discriminator**, not a new QtPlasmaC defect or a repeat of [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md). A circle represented as a polyline may be geometrically equivalent for display/nesting but **not equivalent for QtPlasmaC's automatic G-code hole processing**.

## Immutable source and documentation

- LinuxCNC **v2.9.10** [`src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `4cdae156b94b607bd2514b1573baabc83f396f23`: `parse_code` ~257–383; `do_arc` ~789–799; `check_if_hole` ~830–852; `get_hole_diameter` ~855–889; `overburn` ~891–930.
- LinuxCNC pinned development **`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`**, [same path](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob `aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`: `parse_code` ~313–459, arc dispatch ~439–441; same G02/G03-only branch.
- [Official QtPlasmaC documentation](https://www.linuxcnc.org/docs/2.9/html/plasma/qtplasmac.html), sections *Hole Cutting* and *Hole Cutting - Automatic*: automatic hole sensing disabled by default, modes `#<holes>=1..4`, small-hole feed reduction and optional overcut; explicit arc words required; overcut unavailable with cutter compensation.
- [Stable QtPlasmaC metric simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc) blob `f1e601637a4be2972bc82bf5cd5d5dbcf5488e88`, lines 2–9: `ngc/nc/tap=qtplasmac_gcode`; default G21/G90/M52P1 startup.
- Historical [SVGnest `svgparser.js`](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/svgparser.js), blob `f7f96be13907f41c1fe3e06dc00165b01667e164`, `polygonify` ~611–655 circles/ellipses to point lists, ~753–764 SVG arcs to line segments for *nesting*. **Important:** [`svgnest.js::applyPlacement`](https://github.com/Jack000/SVGnest/blob/1248dc21efd3f90d1aa52ba5785e27e5217ed2c9/svgnest.js#L746-L809) clones original SVG elements; internal polygonization **does not by itself prove** exported SVG has lost native arcs. A later CAM importer/post may or may not tessellate them.

## Exact LinuxCNC call path

The QtPlasmaC filter runs **before** the G-code interpreter. In stable `Filter.process_file` ~169–255, each unfiltered NC line reaches `parse_code`. That method normalizes G-code, tracks units and modal distance/arc-center state, then at ~363–365 calls `do_arc` **only** when the normalized line begins `G02` or `G03`. `do_arc` checks that hole sensing is enabled and not in a conversational block, then invokes `check_if_hole` → `get_hole_diameter`. That function conditionally inserts `M67 E3 Q...` for small-hole velocity and `overburn` conditionally inserts `M62 P3` and another G2/G3 overcut. The pinned development revision retains this arc-only dispatch at ~439–441.

**Causal consequence (SOURCE-CONFIRMED conditional):** A CAM post that represents a round hole exclusively as a sequence of `G1 X... Y...` moves never enters `do_arc` for that contour. Therefore **QtPlasmaC's automatic small-hole recognition cannot infer the circular hole from those G1 segments** in this inspected path, even if the polyline's endpoints close and the display looks circular. It will not automatically insert the arc-triggered `M67`/overcut for that G1-only contour. **This does not mean manual M67/M62 commands are prohibited**, nor that a post cannot reconstruct G2/G3 arcs, nor that every SVGnest/Deepnest export tessellates all curves. The result depends on the *actual NC emitted*.

The pre-existing [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) establishes separate filter state bugs affecting Y-only moves, G91 arcs, coordinate-zero holes and G90.1 J; those remain distinct conditional issues when using G2/G3. [PLASMA-32](4400_LINUXCNC_PLASMA_32_QTPLASMAC_OVERCUT_M62_P3_TP_TIMING_AND_FILTER_SOURCE_AUDIT_2026-10-31.md) separately explains M62 and M67 downstream timing. Neither proves physical arc extinction or hole quality.

## Reproducible discriminator and practical CAM decision

Freeze one physical 10-mm-diameter circle centered at (20,20) mm, start (25,20), under explicit `G21 G17 G90 G91.1` and `#<holes>=1` with an initialized QtPlasmaC filter/material. **Case A** encodes one full circle `G3 I-5 J0`; **Case B** encodes the same contour as a sufficiently fine, closed sequence of G1 XY segments. Hold the material, feed and filter revision constant. Compare *filter output* for injected `M67 E3` and *interpreter geometry* separately. Expected source behavior: A can enter `check_if_hole` and insert a feed reduction when all preconditions hold; B does not enter the arc-specific branch. Do not assume A passes until prior-position state, current material and auto-hole mode are actually established; in particular avoid the known coordinate-zero false-negative. An independent geometric witness should also measure chord error in B.

**Design rule:** Keep source CAD circle/arc identity through nesting when possible, or have the CAM post intentionally reconstruct and validate G2/G3 IJK arcs with correct G91.1/G90.1 semantics and arc-radius tolerance. If choosing G1 tessellation, explicitly encode any required hole-specific process changes in the post and validate the output; do **not** expect QtPlasmaC automatic hole sensing to recover them. Also preserve inside-before-outside cut order, kerf, pierce and torch logic. For press-brake DXF, keep bend lines/datums outside the cut-contour-only model.

## Evidence ledger

| Claim | Evidence | Limit |
|---|---|---|
| QtPlasmaC auto hole branch only dispatches for G02/G03 | SOURCE-CONFIRMED both pinned LinuxCNC revisions | Filter can be customized by `custom_filter.py`; this traces stock path only |
| G1-only polygon does not trigger that branch | SOURCE-CONFIRMED conditional | No actual NC/filter execution |
| Native SVGnest output always loses arcs | **NOT CLAIMED**; source shows cloned original elements | Downstream CAM/export may flatten |
| Correct physical hole quality or torch timing | UNKNOWN | Needs qualified independent process and machine evidence |

The [20+ case practical guide](../guides/4000-linuxcnc-nesting-dxf-svg-plasma-handoff-acceptance-2026-10-31.md) now includes A1–A3; all NOT RUN. No build, simulation, Actions or physical operation; independent evaluator and graduated levels unchanged. [Next checkpoint](../checkpoints/20261031T214200Z-4000-linuxcnc-nesting-cam-next.md).

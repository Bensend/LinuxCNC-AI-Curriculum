# 3300/4000 practical handoff — DXF/nesting → QtPlasmaC kerf, units, arcs and process controls

**Scope:** LinuxCNC v2.9.10 and pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`. Practical 3300 plasma transfer and 4000 implementation, **NON-GRADUATED**. No mandatory product build. No physical machine operation. Prior [nesting/CAM acceptance](4000-linuxcnc-nesting-dxf-svg-plasma-handoff-acceptance-2026-10-31.md) covers geometry conversion and modal arc problems; this guide adds **unit-mode state lifetime and compensation/process feature selection**.

## Architecture boundary

`DXF geometry with declared units → import/block/INSERT transforms → closed contour topology → nesting with transforms → CAM contour offset and lead-in/out → G-code post → QtPlasmaC Python filter → LinuxCNC RS274 interpreter/canonical path → Task/motion/HAL → drive/torch`.

Do not conflate DXF units with machine INI units, HAL kerf-width signal units with G-code D units, or QtPlasmaC filter coordinates with canonical/machine coordinates. OpenPressBrake's bend line/tooling/gauge logic is **not** a plasma kerf offset problem; share only validated DXF parsing, geometry provenance and units conversion.

## Recommended two post contracts

**Contract P (preferred when using automatic small-hole feed/overcut):** Resolve DXF and nesting units before posting; choose one G20/G21 matching the INI, use **G40 throughout**, offset each outer/inner contour in CAM by the appropriate kerf radius, preserve genuine G2/G3 circular holes and explicit motion words, set material with M190/M66 before cutting, and use the documented QtPlasmaC hole mode as needed. Verify the resulting **filtered** M67/M62 and the interpreter's canonical path. This is a design recommendation; the offset geometry and machine-specific process recipe still require independent verification.

**Contract D (dynamic G41.1/G42.1):** Program nominal geometry, use `G41.1 D...` or `G42.1 D...` with **D as diameter**, provide a first compensated XY move strictly **longer than D/2**, and cancel with G40 before material waits/changes. Do **not** rely on QtPlasmaC automatic small-hole velocity control, G-code/velocity THC, or overcut while compensation is active. Do not combine a generated overburn arc with a commented torch-off command. Check actual HAL expression and units in the installed config; `plasmac.kerf-width` and `qtplasmac.kerf_width-f` are netted together in the pinned GUI, but only the latter has the filter's special mixed-unit text rewrite. Prefer native machine/program units.

## Source-based worked examples (illustrative, not run)

1. **Metric INI, material kerf 1.2 mm:** G41.1 D1.2 means **0.6 mm radius** in a G21 program. A first compensated straight move of exactly 0.6 mm is rejected by the source check `distance <= radius`; a larger lead-in is required, with geometry margin and separate path verification.
2. **Same metric INI, G20:** `D#<_hal[plasmac.kerf-width]>` numerically gives 1.2, which the interpreter treats as **1.2 inches**; it is not automatically 0.047244 inches. The filter's legacy `qtplasmac.kerf_width-f` spelling is specially multiplied, but relying on mixed units remains fragile.
3. **Metric INI, G20 then G21:** the filter's `unitMultiplier` remains 0.03937, `minDiameter` remains 1.26 and default overcut length remains 0.157, although program coordinates have returned to mm. With `#<holes>=1`, a 10 mm full-circle G3 and 1.2 mm kerf gives source-calculated 10.023622 vs stale 1.26, so the filter does not enter the small-hole M67 branch.
4. **G41.1 + `#<holes>=2`:** a qualifying explicit G3 can cause the filter to append an overburn G3 **while commenting out** the generated M62 torch-off. Treat this combination as **invalid for production**, even if a software preview seems plausible.

## Disconnected acceptance matrix — all NOT RUN

| ID | Frozen stimulus | Expected *source prediction*, not observed result | Independent evidence needed |
|---|---|---|---|
| U102-1 | Metric INI, G21, explicit 10 mm full-circle G3, hole mode 1 | Native 32 mm threshold; reduced-feed M67 | Filter output + exit |
| U102-2 | Same with G20 then G21 | Stale 1.26 threshold; no reduced-feed M67 for 10 mm hole | Filter output + state/trace |
| U102-3 | Inch INI, G21 then G20 | Stale 25.4 multiplier and 32 threshold | Filter output + state/trace |
| U102-4 | G20/G21 switches with hole mode 2 | Overcut length remains stale after return | Filter output + geometry |
| C103-1 | G40, valid full circle, hole mode 2 | Active M62 before generated overburn | Filter output; canonical interpreter acceptance |
| C103-2 | G41.1, same hole mode 1 | M67 replaced with commented placeholder and warning | Filter output + warnings |
| C103-3 | G41.1, same hole mode 2 | Commented M62 but additional overburn arc | Filter output + warnings; interpreter may reject |
| C103-4 | D=1.2; first comp entry 0.6 vs 0.61 mm | Exactly 0.6 rejected, 0.61 passes this *specific* distance check | Interpreter result; other geometry checks may reject |
| C103-5 | Metric machine, G20, D documented vs legacy HAL alias | Documented D unscaled; legacy spelling rewritten by filter | Filter output + evaluated interpreter D |
| C103-6 | M66 while offsetG4x true vs after G40 | Filter records material-change compensation error while active | Filter error + interpreter result |

**Execution gate:** no run until independently qualified, isolated `[self-hosted, openpressbrake]` software-only compute is established; no GitHub-hosted runners or physical machine I/O. Capture exact LinuxCNC revision, INI and material inputs, original/filtered G-code, stderr/exit, canonical path and warning state. Separate FILTER-CONFIRMED from INTERPRETER-CONFIRMED and from physical machine observations. A successful workflow envelope alone is not proof.

## Review checklist for a CAM/post implementation

- [ ] Input DXF INSUNITS and any INSERT/block transform normalized, nesting scale/rotation retained; no unexamined HPGL 0.025 mm quantization or external conversion service.
- [ ] Single G20/G21 mode matches INI, no unit switching within QtPlasmaC file; material kerf units and tool D units explicit.
- [ ] Inner/outer contour offset direction and lead-in/out reviewed; no double compensation (CAM offset **and** G41.1).
- [ ] G2/G3 emitted explicitly for holes; no unsupported modal compression across G91.1/G64; avoid relying on G1 tessellation for auto-hole recognition.
- [ ] With G40, verify auto-hole M67 and overburn M62 placement in filtered code; with G41.1, **disable incompatible process features** and verify strict lead-in >D/2.
- [ ] Preserve prefilter and postfilter G-code plus source revision and material recipe for reproducibility.
- [ ] Verify canonical path and state in a disconnected interpreter before any separately authorized machine qualification.

**Source anchors:** [PLASMA-102](../research/4400_LINUXCNC_PLASMA_102_QTPLASMAC_G20_G21_STICKY_UNIT_STATE_SOURCE_AUDIT_2026-11-01.md), [PLASMA-103](../research/4400_LINUXCNC_PLASMA_103_G411_KERF_HAL_LEADIN_OVERCUT_SOURCE_DOC_AUDIT_2026-11-01.md), [CAM-80](../research/4400_LINUXCNC_CAM_80_QTPLASMAC_G1_TESSELLATED_HOLES_VS_G2_G3_AUTO_PROCESS_SOURCE_AUDIT_2026-10-31.md), [PLASMA-81](../research/4400_LINUXCNC_PLASMA_81_QTPLASMAC_MODAL_ARC_LASTG_AND_G911_REWRITE_SOURCE_AUDIT_2026-10-31.md), [QtPlasmaC official docs](https://www.linuxcnc.org/docs/2.9/html/plasma/qtplasmac.html), [LinuxCNC G-code docs](https://www.linuxcnc.org/docs/2.9/html/gcode/g-code.html). [Continuation checkpoint](../checkpoints/20261101T053300Z-4000-linuxcnc-plasma-kerf-units-next.md).
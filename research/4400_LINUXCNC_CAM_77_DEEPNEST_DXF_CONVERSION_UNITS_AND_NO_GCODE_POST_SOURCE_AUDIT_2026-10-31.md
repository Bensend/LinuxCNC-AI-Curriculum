# 4000-LC-CAM-77 — Deepnest DXF/SVG nesting is not an offline LinuxCNC CAM post

**2026-10-31 | 3300 plasma / 3600 press-brake CAD handoff / active 4000 implementation | NON-GRADUATED.** This is a *historical pinned-source* integration audit, not a claim about current Deepnest distributions or a tested machine. LinuxCNC itself remains the downstream controller. The increment over [CAM-02](4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md), [CAM-38](4400_LINUXCNC_CAM_38_OPENBUILDS_DXF_NESTED_INSERT_UNITS_GCODE_SOURCE_AUDIT_2026-10-31.md), and [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) is **the nesting tool's actual import/export and postprocessing boundary**, not another claim that all DXF parsers lose geometry.

## Pinned evidence and execution map

- Original public [Jack000/Deepnest commit `2fb10513a30681971dcc991c528fa0738a2c0c76`](https://github.com/Jack000/Deepnest/commit/2fb10513a30681971dcc991c528fa0738a2c0c76), **published 2018-08-26**, inspected 2026-10-31. No current-release or maintained-fork behavior inferred.
- [`main/index.html`](https://github.com/Jack000/Deepnest/blob/2fb10513a30681971dcc991c528fa0738a2c0c76/main/index.html) blob `a119f706183bd6906aecbbcb5bc525cf24662030`: defaults ~72–89, file import ~565–650, export ~984–1185, unit selectors ~1739–1758.
- [`main/deepnest.js`](https://github.com/Jack000/Deepnest/blob/2fb10513a30681971dcc991c528fa0738a2c0c76/main/deepnest.js) blob `97e0166d5f1fce2c7b38d079fa04dcbfed0e13d2`: `importsvg` ~58–75, placement export ~1241.
- [`main/svgparser.js`](https://github.com/Jack000/Deepnest/blob/2fb10513a30681971dcc991c528fa0738a2c0c76/main/svgparser.js) blob `f7059c50f374d5f790a05f4ef237335240362859`: `load` ~50–144 converts SVG `width`/`viewBox` to local units and applies `scalingFactor`; `cleanInput` ~148.
- LinuxCNC stable **v2.9.10**, [real QtPlasmaC metric INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtplasmac/qtplasmac_metric_ini.inc) blob `f1e601637a4be2972bc82bf5cd5d5dbcf5488e88`, lines 2–9: `[FILTER] ngc/nc/tap=qtplasmac_gcode`, startup `G21 ... M52P1`; [filter](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py) blob `4cdae156b94b607bd2514b1573baabc83f396f23`. These are independent **NC preflight**, not a Deepnest post.

**Actual path:** UI file selection → for DXF/CDR, `request.post(conversionServer)` with file upload, format SVG → callback `importData(body,...,dxfImportScale,dxfFlag)` → `DeepNest.importsvg` → `SvgParser.load(...scalingFactor)` → `clean` → polygon/nest placement. SVG import instead reads locally. Export SVG is local `exportNest` → `fs.writeFileSync`; export DXF is `exportNest(...,true)` SVG → remote conversion server → write returned DXF. There is **no executed G-code exporter** in the inspected UI.

## Findings and causal boundaries

**D1 — DXF input and output depend on an external conversion service (SOURCE-CONFIRMED).** Default `conversionServer` is `http://convert.deepnest.io` (index ~88). Non-SVG input posts to it (~584–627), and DXF export posts to it (~1021–1048). Availability, TLS, server implementation, retention and the current service's existence are **UNKNOWN**. In an isolated/disconnected lab, a DXF→nest→DXF test cannot be assumed runnable. A preconverted, locally verified SVG input is a different test and does **not** verify DXF conversion.

**D2 — Unit interpretation is explicit configuration, not a self-verifying DXF contract (SOURCE-CONFIRMED).** Defaults are `units:'inch'`, internal `scale:72`, `dxfImportScale:'1'`, `dxfExportScale:'72'` (~72–89). The import selector labels `1=Points`, `72=Inches`, `2.83465=mm` (~1739–1747); the export selector has its own scale choices (~1750–1758). `SvgParser.load` separately reads SVG `width` and `viewBox`, infers pixels/inch for SVG length units and combines a supplied `scalingFactor`. **INFERENCE:** an incorrectly selected DXF unit can scale parts and kerf/spacing incorrectly. No numerical field scale is asserted without observing the conversion server's SVG and the exact selected settings. Capture the original DXF `$INSUNITS`, selected import/export scales, returned SVG dimensions, physical witness dimension and NC `G20/G21` independently.

**D3 — G-code export is present only in a JavaScript comment (SOURCE-CONFIRMED).** The entire `exportgcode.onclick` block (~1052–1098) is inside `/* ... */`. Do not advertise this pinned revision as a LinuxCNC postprocessor or use a dormant `format=gcode` form as evidence of a working post. A separate CAM stage must generate and validate pierce/torch, lead-in, contour order, feed, material, units and post-specific G-code.

**D4 — Common-line merging changes the contour contract (SOURCE-CONFIRMED path; process consequence INFERENCE).** In `exportNest` (~1168–1173), when `mergeLines` and `n.mergedLength>0`, the tool applies transforms, flattens, splits lines, merges overlap and merges lines before export. This can intentionally turn two touching part edges into one geometric edge. It does **not** establish correct plasma pierce sequencing, inside-before-outside cuts, kerf side, or safe torch-off motion. A post must distinguish a **shared cut edge** from a contour identity and revalidate cut sequencing. Do not feed merged geometry blindly to an outside-contour post.

**D5 — SVG output is dimensioned but not NC (SOURCE-CONFIRMED).** `exportNest` uses a `viewBox` in internal coordinates and writes width/height in `in` or `mm` based on UI settings (~1153–1166), with nested groups transformed for placement (~1119–1146). An SVG viewer can show a plausible nest even if the eventual CAM importer applies different CSS-pixel or viewBox semantics. Record one dimensional witness and the transform chain before any G-code generation.

## LinuxCNC implementation handoff

The stable QtPlasmaC INI explicitly uses `qtplasmac_gcode` as a **filter before the interpreter**; its G-code filter has separate hole-detection/material/torch logic already audited in [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) and [PLASMA-32](4400_LINUXCNC_PLASMA_32_QTPLASMAC_OVERCUT_M62_P3_TP_TIMING_AND_FILTER_SOURCE_AUDIT_2026-10-31.md). The nesting stage must **not** be allowed to stand in for a LinuxCNC/QtPlasmaC-specific post. A valid pipeline is: source DXF → geometry normalization with IDs/units/holes → nesting with transforms and optional shared-edge plan → CAM process plan → explicit QtPlasmaC NC post → filter/interpreter preflight → separately qualified machine. Press-brake bend lines and gauging datums are **not** generic cut contours; retain them outside a 2D nesting-only geometry model.

## Evidence ledger, independent verification and next work

| Claim | Class | Still missing |
|---|---|---|
| DXF conversion is HTTP POST, SVG import local | SOURCE-CONFIRMED historical | actual server response, offline alternative |
| Import/export units configurable and independent | SOURCE-CONFIRMED historical | DXF→SVG physical dimensions and roundtrip |
| G-code UI handler commented out | SOURCE-CONFIRMED historical | maintained-fork review if needed |
| Common-line merge changes exported geometry | SOURCE-CONFIRMED path | generated contours, cut sequencing, kerf/pierce validation |
| Any LinuxCNC cut is correct/safe | UNKNOWN | isolated NC filter/interpreter, independent physical acceptance |

**Frozen practical cases:** see [nesting-to-LinuxCNC acceptance guide](../guides/4000-linuxcnc-nesting-dxf-svg-plasma-handoff-acceptance-2026-10-31.md). ALL NOT RUN. No source patch or product build proposed. No physical operations, no Action jobs or independent evaluator. This source-only work does not graduate a level or release any machine. **Next checkpoint:** [2026-10-31 nesting/CAM](../checkpoints/20261031T214200Z-4000-linuxcnc-nesting-cam-next.md).

# 4000-LC-CAM-04 — Current PathForge DXF→G-code versus LinuxCNC: unsupported entities and G04 X dwell
**2026-10-30 | SOURCE-CONFIRMED pinned 2026 PathForge and LinuxCNC v2.9.10; DOC-CONFIRMED G4 syntax | no runtime | NON-GRADUATED**

## Why this follow-up exists
The [historical DXF2GCODE audit](4400_LINUXCNC_DXF2GCODE_02_BULGE_BLOCK_ELLIPSE_POST_ARC_VALIDATION_SOURCE_AUDIT_2026-10-30.md) exposed a 2016 block-transform/post arc hazard but cannot characterize modern alternatives. The information-gain question is: **does a newer maintained open-source DXF→G-code converter preserve more DXF entities and emit LinuxCNC-valid process G-code?** The answer for this one pinned implementation is mixed and contains a concrete cross-project syntax mismatch.

## Immutable sources
- [PathForge repository](https://github.com/shaahid-ahmed/PathForge/tree/f3574ec11450ea34ae861487efd64367746ab8bc) at commit **`f3574ec11450ea34ae861487efd64367746ab8bc`**, 2026-07-11. This is newer than the historical 2016 DXF2GCODE snapshot, but is **not** asserted to be the latest release at the time of a later run.
- [PathForge README](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/README.md) advertises support for LINE/ARC/CIRCLE/SPLINE and broadly claims compatibility with LinuxCNC and other controllers. That is a **project claim**, not TEST-CONFIRMED compatibility.
- [`converter.py`](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/src/pathforge/converter.py) ~12–80 calls `ezdxf.filemanagement.readfile/read` then `GcodeBuilder.build/stream`.
- [`codegen/builder.py`](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/src/pathforge/codegen/builder.py) ~25–75, 150–220 defines supported entity types and dispatch.
- [`codegen/entity_writers.py`](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/src/pathforge/codegen/entity_writers.py) ~13–161 emits per-entity G-code.
- [`codegen/header.py`](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/src/pathforge/codegen/header.py) ~1–15 defines header, footer and spindle/dwell templates.
- LinuxCNC v2.9.10 [`interp_check.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_check.cc) ~84–90 checks **G4 requires P**; [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) ~2363–2366 passes `block->p_number` to `convert_dwell`; [official 2.9 G4 documentation](https://www.linuxcnc.org/docs/2.9/html/gcode/g-code.html) specifies `G4 P-`.

## Finding A — ezdxf dependency does not imply ezdxf feature coverage
`GcodeBuilder._SUPPORTED_TYPES` is **exactly `{"LINE","ARC","CIRCLE","SPLINE"}`**. It loops through `doc.modelspace()` and, for other types, appends `Skipped unsupported entity type` to a warning list and **continues**. The `ConversionResult` has a `warnings` field, but an otherwise nonempty supported drawing can still yield G-code while LWPOLYLINE (including bulged profiles), ELLIPSE, INSERT and MINSERT have been omitted. If no supported entities remain, it raises `EmptyDocumentError`.

This is SOURCE-CONFIRMED **for this pinned builder**, not a claim that ezdxf cannot process those types: the [prior pinned ezdxf audit](4400_DXF_EZDXF_01_BULGE_INSERT_NONUNIFORM_MINSERT_SOURCE_AUDIT_2026-10-30.md) explicitly traces richer `virtual_entities`, bulge and block transform support. A library's capabilities do not automatically transfer to a consumer that filters types before geometry normalization. **Consequence:** a DXF containing one supported LINE plus many unsupported contours may produce a plausible but incomplete NC file. Whether the caller checks the returned warning list is application-specific; the library itself exposes it.

## Finding B — emitted `G04 X...` conflicts with LinuxCNC G4 P
In **all four** PathForge entity writer functions, the initial tool entry branch writes `M03 S1000` followed by `G04 X{dwell_time}`; `header.py` repeats the same `G04 X` template. Default dwell is 0.5 s in [`models.py`](https://github.com/shaahid-ahmed/PathForge/blob/f3574ec11450ea34ae861487efd64367746ab8bc/src/pathforge/models.py) ~15–23. LinuxCNC v2.9.10 `interp_check.cc` explicitly checks `block->p_number == -1.0` for G4 and reports missing dwell time. **The source-level prediction is that an emitted `G04 X0.5` without P is rejected**, assuming this code path is reached and no preprocessor rewrites it. This was **not** run in LinuxCNC; the outcome is a SOURCE-CONFIRMED syntax mismatch and INFERENCE about exact runtime reporting.

The fix concept is **not** to loosen LinuxCNC: a LinuxCNC-specific post must emit `G4 P...` and validate the full NC modal context. The library's README compatibility claim should be treated as unverified for the pinned release.

## Finding C — post modal and process assumptions are not neutral
`gcode_header` emits `G94`, feed `F...`, and `G21`; it does **not** explicitly emit `G90`, `G17`, or `G91.1`. Writers use G0/G1 and G2/G3 (arc writer uses R-format; circle writer uses I/J). The footer emits `M05`, `G53 G0 X0 Y0`, `M30`. This is a machine-coordinate rapid command with no independently verified Z clearance, soft-limit check or machine-specific park location. The initial process sequence hardcodes `M03 S1000` and a dwell, not QtPlasmaC's [M190/M66 material handoff](4400_LINUXCNC_QTPLASMAC_M190_M66_MATERIAL_HANDOFF_SOURCE_AUDIT_2026-10-30.md). The footer and header are SOURCE-CONFIRMED text templates; machine-specific motion/process consequences remain UNKNOWN.

The source uses **R-format** for ARC rather than I/J and emits a full circle with I/J. That changes the numerical acceptance questions compared with the older DXF2GCODE post, but does not establish accuracy. Review radius sign, endpoints, precision and modal state against LinuxCNC's documented G2/G3 rules; do not assume any post is controller-neutral.

## Comparison and acceptance contract
| Capability / hazard | Historical pinned DXF2GCODE (2016) | Pinned PathForge (2026) | Acceptance decision |
|---|---|---|---|
| LWPOLYLINE bulges | Parses and converts to `ArcGeo` | Skips with warning | Must normalize and verify; neither alone is a complete DXF acceptance contract |
| Direct ELLIPSE | Sampled biarc approximation | Skips with warning | Reject or explicitly bounded approximation |
| INSERT / MINSERT | INSERT recursion, but no MINSERT grid; nonuniform ARC problem | Skips INSERT | Expand source with correct transforms/identity or reject |
| DXF source handle provenance | Not retained in inspected importer/post | No source-handle NC manifest in inspected builder | Preserve independent source→NC manifest |
| G2/G3 export | I/J, large-radius arc can become G1 chord | R for ARC; I/J for CIRCLE | Review each post separately against interpreter |
| LinuxCNC G4 dwell | Milling-style post; no finding of X-dwell in inspected path | **G04 X** on initial entry | Reject for LinuxCNC; require G4 P |
| Modal/park/QtPlasmaC | G64/G17/G90/G21 mill-oriented default | G94/G21 header, machine-coordinate XY park, M03 | Machine-specific post required |
| Runtime proof | NONE | NONE | Neither source inspection certifies machine readiness |

**Unscored transfer prompt:** A DXF contains one LINE, one bulged LWPOLYLINE and a repeated block. A post produces NC with the LINE only and a first-entry `G04 X0.5`. Which two independent faults occur, and which are discoverable by comparing (a) source entity manifest, (b) warnings, (c) emitted NC, and (d) LinuxCNC interpreter check? A correct response does not treat successful file creation as successful geometry conversion.

## Evidence and next
- **SOURCE-CONFIRMED:** pinned entity filter and warning behavior; pinned PathForge `G04 X` templates; LinuxCNC G4 P check; header/footer text; exact supported types.
- **DOC-CONFIRMED:** PathForge README claims controller compatibility; official LinuxCNC G4 P requirement.
- **INFERENCE:** expected interpreter rejection for representative emitted `G04 X0.5` without P, conditional on execution path.
- **UNKNOWN:** installed-machine behavior, generated NC from a real fixture, actual test coverage, current later PathForge release, physical output, any claimed controller compatibility.
- **TEST-CONFIRMED:** **none**. No workflow, Actions runner, build, test suite, simulation, CNC machine or physical operation used.

**Next information-gain step:** Compare a current FreeCAD CAM or another production-style LinuxCNC-specific post that *explicitly* normalizes LWPOLYLINE/INSERT and emits G4 P; alternatively prepare a **source-only upstream issue packet** for the pinned PathForge G04 X mismatch and skipped-entity warning semantics. Do not manufacture a product build or change machine safety authority. Existing OpenPressBrake G0/G1 remains HOLD; external evaluator state unchanged.

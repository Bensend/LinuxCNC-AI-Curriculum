# 4000-LC-LATHE-173 — G7/G8 plus G76 on the same block: double-normalized thread depths

**Status (2026-11-02): SOURCE-CONFIRMED conditional branch, DOC-CONFIRMED intended units, NUMERIC INFERENCE for canonical X; NOT RUN / NOT TEST-CONFIRMED.** 3200 lathe programming and 4000 interpreter/CAM-post transfer, NON-GRADUATED. No hardware, LinuxCNC runtime, or machine-operation evidence.

## Precise novelty and predecessor check

The 2026-09-14 [3200 G76 pass-generation trace](3200-g76-pass-generation-source-trace-2026-09-14.md) already documents ordinary G7 halving and the canonical threading pass. [LATHE-35](4400_LINUXCNC_LATHE_35_G76_G33_SYNC_FEED_FEASIBILITY_AND_OVERRUN_VERSION_SOURCE_AUDIT_2026-10-31.md) covers feed feasibility; [LATHE-107](4400_LINUXCNC_LATHE_107_G76_D_MULTISTART_VERSION_CANON_TP_UI_SOURCE_AUDIT_2026-11-01.md) covers D/phase; [LATHE-108](4400_LINUXCNC_LATHE_108_G76_H_MINUS1_FULL_DEPTH_R_E_L_VALIDATION_SOURCE_DOC_AUDIT_2026-11-01.md) covers H/R/E/L validation. This audit isolates **the same-block modal transition**, a separate mechanism: two independent I/J/K conversions run when G7/G8 changes on the very G76 block. Do not re-teach ordinary G76 as a new discovery.

## Pinned primary sources

- Stable LinuxCNC **v2.9.10**: [interp_read.cc#L3317-L3337](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_read.cc#L3317-L3337) (stable `Interp::read_x`; blob `93333860904996732f9fa96f239263c991b2dfd6`), [interp_convert.cc#L2163-L2201](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L2163-L2201), [#L2368-L2379](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L2368-L2379), [#L5068-L5110](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L5068-L5110); converter blob `f01a359652d588d59c9e210fa441a99d2ee19598`.
- Development pinned **67437d8865e431a9a33f74cee912dbf891d3b4c5**: [interp_convert.cc#L2791-L2829](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_convert.cc#L2791-L2829), [#L3001-L3008](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_convert.cc#L3001-L3008), [#L5994-L6040](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_convert.cc#L5994-L6040), [#L5945-L5992](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/emc/rs274ngc/interp_convert.cc#L5945-L5992); converter blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`.
- Official G76 semantics: [stable docs#L1960-L1985](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/g-code.adoc#L1960-L1985), blob `461c9eae52a9baf4b69895a6b84df250491953cf`; [development docs#L2373-L2397](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/gcode/g-code.adoc#L2373-L2397), blob `46386681cce284fa0cc43e27192bee0aca208766`. Both specify G7 I/J/K as **diameter**, G8 I/J/K as **radius**.
- Existing upstream executable **test source, not executed**: [tests/interp/g76/g76only.ngc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/tests/interp/g76/g76only.ngc), blob `c8dfc9913ce8288b3e708db4c4c970cebc3ae3c1`, plus `test.sh`/`expected`. It runs G76 with **no G7/G8 same-block transition**, so it cannot distinguish this branch. The bundled [g76diam.ngc](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/nc_files/ngcgui_lib/lathe/g76diam.ngc) contains a separate G7 initial-J workaround; do not confuse that with the present same-block defect.

## Mechanism: read -> modal change -> threading conversion

1. `Interp::read_i/j/k` stores raw real words in `block->i_number/j_number/k_number`; unlike `read_x`, it does not normalize for lathe diameter mode. `read_x` normalizes using **the previous** modal state.
2. `Interp::convert_g` executes modal group 15 (`convert_lathe_diameter_mode`) **before** motion group 1 (`convert_motion` -> `convert_straight` -> `convert_threading_cycle`).
3. On **G8 -> G7** with `motion_to_be == G_76`, `convert_lathe_diameter_mode` divides I/J/K by 2 and sets `lathe_diameter_mode=true`. Then `convert_threading_cycle` divides the same three words by 2 **again**, yielding 1/4 of programmed I/J/K.
4. On **G7 -> G8**, the modal converter multiplies I/J/K by 2 and sets `lathe_diameter_mode=false`; the threading converter no longer halves, yielding **2x** the programmed radial I/J/K.
5. If G7 or G8 is on a **separate preceding block**, the modal converter sees no G76 words to adjust, and `convert_threading_cycle` normalizes exactly once. Repeating the *already-active* mode on a G76 block also skips the conditional conversion.
6. `threading_pass` receives `safe_x` and `depth`; for a non-boring, non-tapered first pass, the cutting X is `safe_x - (abs(I_internal)+abs(J_internal))`. The end-depth radial target is `abs(I_internal)+abs(K_internal)`. These are **canonical program-path arithmetic**, not measured cuts.

The checker permits G76 I/J/K and G7/G8 are in a distinct modal group. No prohibition of their coexistence was identified in the inspected ordinary check path. Whether the complete interpreter accepts every proposed fixture and whether canonical outputs match this arithmetic remain **RUNTIME UNKNOWN**.

## Frozen numeric differential (mm, X machine/canonical radius=10, Q0 R1 H0, no taper)

| Case | Mode before G76 | Block on cycle | Effective I,J,K in radial mm (source inference) | First cutting X | Full-depth X |
|---|---|---|---|---:|---:|
| A control | G8 | G76 I-1 J0.2 K1 | -1,0.2,1 | 8.8 | 8.0 |
| B control | G7 | G76 I-2 J0.4 K2 | -1,0.2,1 | 8.8 | 8.0 |
| C suspect | G8 | **G7 G76** I-2 J0.4 K2 | -0.5,0.1,0.5 | **9.4** | **9.0** |
| D suspect | G7 | **G8 G76** I-1 J0.2 K1 | -2,0.4,2 | **7.6** | **6.0** |

All four cases describe the same intended geometry if G7/G8 units are interpreted once. Differences C/D are **predicted** by the pinned implementation; no test has observed them. The 1/4 versus 2x scaling affects I/J/K, not pitch P or the Z endpoint. The physical significance depends on actual stock/tool/clearance and must not be inferred from source alone.

## Review-only correction and verification gate

The [stable review-only patch](../examples/4000_g76_mode_173/stable_2910_g76_same_block_review_only.patch) removes **only** I/J/K rescaling in `convert_lathe_diameter_mode`; it preserves X correction needed because `read_x` already scaled under the previous mode. `convert_threading_cycle` remains the sole owner of G76 I/J/K conversion. The same source hunk is present in the inspected development revision. **Patch is NOT APPLIED, BUILT OR TESTED.** Do not alter G76 global geometry or remove X conversion as a shortcut.

[Disconnected four-case reproduction](../guides/3200-4000-linuxcnc-g76-g7-g8-same-block-reproduction-2026-11-02.md) defines a frozen A–D oracle, existing upstream regression control and proposed patched-vs-original comparison. If an interpreter refuses same-block G7/G76, record that as a rejected input and revise the hypothesis; do not force the numeric prediction into a TEST-CONFIRMED claim.

## Boundaries and next work

- The original upstream G76 test is an **existing oracle for ordinary G8 behavior**, not a new passing test. No local or Actions execution occurred.
- An interpreter canonical trace is not a verified spindle-sync result, actual servo trajectory or cut. Physical spindle readiness, tooling and independent personnel-safety authority remain separate.
- The regression should test both transitions and both separate-block controls, then compare original/patched stable and development. Only run on independently qualified disconnected `[self-hosted, openpressbrake]` if the frozen experiment is justified; no hosted runner.
- This finding neither reopens graduated 3200 nor changes OpenPressBrake G0/G1 HOLD.
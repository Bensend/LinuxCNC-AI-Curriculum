# PLASMA-208 — FreeCAD arc-word suppression and plane-dependent IJK (2026-11-04)

Status: **SOURCE-CONFIRMED narrow / NON-GRADUATED / NOT EXECUTED**. LinuxCNC implementation is primary; FreeCAD is an upstream G-code producer, not a verified QtPlasmaC plasma post.

## Immutable source and entry path
- FreeCAD commit `0cafef1e58284d08a244f9eba85aee0002e3e350`, `src/Mod/CAM/Path/Post/Processor.py` (blob `ecab0e9e6255bb9a7bc3261e4dc2a399ab6dd668`), lines 3490–3540, 3690–3817.
- `src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py` at same commit: class `Linuxcnc(PostProcessor)`, default preamble `G17 G54 G40 G49 G80 G90`.
- Prior: PLASMA-197/198 (QtPlasmaC arcs, ezdxf bulges), PLASMA-206/207 (post inheritance, units), MOTION-191 (G64).
- LinuxCNC stable source pin for subsequent interpreter comparison: `86cdca76fa2a36274c432caa21952b23c267989a` (v2.9.10 peeled tag). **No G90.1/G91.1 interpreter source conclusion is claimed in this lesson.**

## Verified source trace
1. The common command dispatcher routes `G2/G3` to `_convert_arc_move`, which returns `_convert_move(command)`. It formats existing `Path.Command.Parameters`; it does **not** compute the arc center from endpoints or verify its radius.
2. `_convert_move` obtains the current plane from `machine_state.Plane`, falling back to `G17` when state is absent. It excludes the center word **normal to the plane** (K for G17, J for G18, I for G19) before formatting. Helical travel on the normal axis remains a distinct XYZ parameter.
3. With `OUTPUT_DOUBLES` false, the formatter suppresses a parameter only when it is in `machine_state.Tracked` **and** its value equals `machine_state.previous[parameter]`. This code alone does **not** prove I/J are tracked, or that arc offsets are suppressed across successive arcs. The tracking-set initialization and state-update ordering require a separate trace. With no emitted parameters, it returns None for moves.
4. `format_parameter` scales I/J/K/R like length words (mm or in); it does not translate them from absolute to incremental arc centers. Therefore the producer's center convention and interpreter G90.1/G91.1 mode remain an open interface dependency.
5. The LinuxCNC post default preamble explicitly sets G90 but not G90.1/G91.1. G90 endpoint mode is insufficient to establish arc-center interpretation. This is a **mode-contract gap**, not proof that FreeCAD's generated arcs are incorrect.
6. FreeCAD `linuxcnc_post.py` includes tilted-plane syntax tied to a draft LinuxCNC PR. Do not assume this post's newest multi-axis output is accepted by pinned LinuxCNC 2.9.10 without independent version checking.

## Practical disconnected verification design — no results asserted
- **A (plane):** Give a G17 Path.Command G3 with X/Y/I/J/K; inspect whether K is excluded while Z helix word remains. Repeat G18 and G19, changing only the excluded center word. Compare exact emitted strings.
- **B (center offsets):** Two successive arcs with numerically equal I/J but distinct starts. Capture `machine_state.Tracked`, `previous`, and `OUTPUT_DOUBLES`; ensure the second arc's required center offsets survive. A missing offset would change geometry; this is a conditional risk, not an observed defect.
- **C (mode):** Same endpoints, same numeric I/J, different G90.1 versus G91.1. Verify the LinuxCNC interpreter's actual center/radius or error. Require explicit G17/G20-or-G21 and arc-center mode in any adapter contract.
- **D (unit conversion):** For start (10,0), end (0,10), center (0,0), expect relative I=-10,J=0 in mm, or I=-0.3937008,J=0 in inches. Do not treat analytical values as FreeCAD output.
- **E (modal):** Repeated identical XYZ moves versus distinct arcs; distinguish intentional endpoint modal suppression from required per-arc offsets. Confirm state update ordering, not only `_convert_move`.
- **F (plasma):** Verify separately that any eventual plasma adapter handles M190/M66/#5399, torch M3/M5, feed and pierce sequence; no FreeCAD generic post is authorized for a physical machine.

## Evidence / dependency ledger
**SOURCE-CONFIRMED:** dispatcher and formatter, plane-normal IJK exclusion, conditional duplicate-suppression predicate, absence of arc-center declaration in default preamble. **NOT VERIFIED:** FreeCAD Path.Command IJK construction, tracked-word set, state update ordering, stable LinuxCNC arc-center default, executable G-code output, QtPlasmaC runtime. No tests, builds, Actions or machine activity; zero new lab compute.

**Next:** inspect FreeCAD `machine_state.Tracked` initialization and state updates, locate upstream arc test fixtures, then compare with LinuxCNC 2.9.10 G90.1/G91.1 implementation. If evidence gain stalls, rotate to HostMot2/Mesa or realtime motion source. Preserve blind/evaluator separation, independent personnel safety, physical HOLD, and self-hosted-only compute gate.

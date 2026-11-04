# PLASMA-207 — FreeCAD inherited arc formatter and modal/unit boundary (2026-11-04)

Status: **SOURCE-CONFIRMED narrow; NON-GRADUATED; NOT EXECUTED**. Continuation of PLASMA-206. No physical-machine approval.

## Source provenance
- FreeCAD immutable commit `0cafef1e58284d08a244f9eba85aee0002e3e350`.
- `src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py`: `Linuxcnc(PostProcessor)`, `get_common_property_schema`, `_get_blend_command`.
- `src/Mod/CAM/Path/Post/Processor.py` blob `ecab0e9e6255bb9a7bc3261e4dc2a399ab6dd668`: `_expand_split_arcs` lines 1432–1446; `_collect_unit_command` lines 1853–1866; `format_parameter` lines 3621–3700; `_convert_arc_move` lines 3811–3817.
- `src/Mod/CAM/Path/Post/Utils.py` blob `fbf82c2fcaf0840200399c2aead7680be0a76250`: `splitArcs` near line 343.
- Prior geometry source: PLASMA-198 pinned ezdxf negative-bulge normalization; PLASMA-197 QtPlasmaC start-relative I/J.

## Source-grounded implementation trace
1. `Linuxcnc` inherits `PostProcessor`; it does not override `_convert_arc_move` in the inspected class. The base implementation delegates G2/G3 to `_convert_move(command)` (Processor.py 3811–3817). This is **not** evidence of geometric validation, correct arc plane, or origin semantics by itself.
2. The base `format_parameter` converts X/Y/Z/U/V/W **and I/J/K/R** as linear distances; imperial divides by 25.4, metric retains millimeters (3623–3631, 3670–3686). Rotary A/B/C use angle formatting, not length conversion. Feed F converts mm/s to mm/min (multiply by 60), then applies the length unit conversion (3640–3646).
3. `_collect_unit_command` emits G21 for metric or G20 for imperial (1853–1866). The Linuxcnc class's default preamble includes `G17 G54 G40 G49 G80 G90`; **G90 is distance mode, not a guarantee of IJK arc-center mode**. The inspected preamble does not explicitly emit `G91.1` or `G90.1`. Therefore correctness of I/J requires verifying the upstream Path.Command center convention and the LinuxCNC active arc-center mode, not assuming either from this post.
4. If machine setting `SPLIT_ARCS` is true, `_expand_split_arcs` replaces G2/G3 commands with linear segments via `PostUtils.splitArcs` (1432–1446). This creates a second output mode with different approximation/contour tolerance behavior; it is not a substitute for verifying the native-arc path.
5. Linuxcnc's blend selection from PLASMA-206 remains a separate motion contract. `G64 P...` can join/approximate segments under LinuxCNC semantics; do not conflate postprocessor axis rounding, arc splitting deflection, and G64 P/Q path tolerance.

## Practical interface contract for DXF -> CAM -> LinuxCNC / QtPlasmaC
- Preserve original DXF traversal order and signed bulge before any CCW-normalized geometry library conversion; positive bulge -> G3, negative -> G2 in the unmirrored XY plane. Verify transformed/mirrored orientation independently.
- At the post boundary, require an explicit **arc-center-mode declaration** (normally `G91.1` for start-relative I/J), explicit G17 and G20/G21, and verify the emitted I/J is relative to the actual emitted start point. Do not insert G91.1 blindly into an existing machine program without checking its upstream command convention.
- In imperial, convert both endpoint and I/J offsets by the same 25.4 factor. Feed is per minute in emitted units; input Path F is per second. Preserve sufficient precision to keep start/end radii equal within LinuxCNC arc tolerance.
- If SPLIT_ARCS is enabled, verify chordal error, arc orientation, cut-side/kerf compensation, lead-in topology and G64 interaction on the **linearized** result.
- QtPlasmaC material-change M190/M66, HAL feed, M3/M5, pierce/torch-height and failure handling remain separate adapter requirements. The generic FreeCAD post is **not** a QtPlasmaC-ready plasma post.

## Disconnected, frozen review oracles (NOT TEST-CONFIRMED)
A. Metric XY: start (10,0), end (0,10), center (0,0), CCW: G17 G21 G91.1 followed by `G3 X0 Y10 I-10 J0`; both radii 10 mm.
B. Imperial same geometry: `G20`, `G3 X0 Y0.3937008 I-0.3937008 J0`; check start X0.3937008, center origin and numerical tolerance.
C. Negative-bulge clockwise half-circle: start (0,0), end (10,0), center (5,0), G2 I5 J0. A G3 with same center/end traverses opposite half-plane; radius checks alone cannot distinguish.
D. A modal `G90.1` inherited from a preceding program with start-relative I/J can change arc geometry or error; demand explicit mode and validate on isolated interpreter.
E. SPLIT_ARCS on/off should produce different G1 vs G2/G3 syntax but equivalent contour within a specified chordal tolerance; test orientation and bounding box, not just endpoints.
F. Check that output feed `F1.0` Path mm/s becomes 60 mm/min or approximately 2.362205 in/min, with rounding according to configured feed precision.
These are **analytical predictions**, not observed LinuxCNC or FreeCAD output.

## Unresolved / next evidence
- Inspect `_convert_move` and modal suppression, Path.Command's I/J producer and FreeCAD arc tests to determine whether IJK are start-relative or absolute at the Path level. Identify G90.1/G91.1 handling in pinned LinuxCNC 2.9.10 source and its defaults.
- Find an upstream NC output fixture with G2/G3 and verify emitted values; execute only if a permitted isolated self-hosted runner is available and a frozen oracle justifies compute.
- Existing blind feedback and safety gates are untouched. No action runners, builds or physical machine operations.

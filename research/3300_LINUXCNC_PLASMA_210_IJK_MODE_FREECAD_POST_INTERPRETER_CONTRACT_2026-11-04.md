# PLASMA-210 — LinuxCNC 2.9.10 IJK arc-center contract at the FreeCAD post boundary (2026-11-04)

Status: **SOURCE-CONFIRMED interpreter behavior / NUMERIC INFERENCE fixture / NOT RUN**. Non-graduated 3300/4000 cross-track research.

## Question and source provenance
PLASMA-209 closed the arc-word deduplication question, but not whether FreeCAD's upstream Path command producer supplies absolute centers or start-relative offsets. This lesson deliberately **does not** infer a producer convention from the formatter. Source inspected directly:

* LinuxCNC stable v2.9.10 [interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc), functions `Interp::convert_ijk_distance_mode`, `Interp::convert_arc`, `Interp::convert_arc2`, `Interp::convert_arc_comp1`.
* FreeCAD pinned [linuxcnc_post.py](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py), `Linuxcnc.get_common_property_schema`.
* FreeCAD pinned [Path/Post/Command.py](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/Command.py): post invocation and file writing, **not** a demonstrated geometric G2/G3 command producer.
* Previous PLASMA-207–209: common movement formatting, tracked state, arc-word retention; these are predecessor evidence, not runtime evidence.

## Confirmed implementation chain
1. `convert_ijk_distance_mode(G_90_1)` sets `settings->ijk_distance_mode = MODE_ABSOLUTE`; `G_91_1` sets `MODE_INCREMENTAL`. This is **independent of G90/G91 linear endpoint mode**.
2. `convert_arc` dispatches G17 XY I/J, G18 XZ K/I, and G19 YZ J/K to `convert_arc2`, with plane-specific current/end coordinate ordering.
3. Without an R word, `convert_arc2` calls `arc_data_ijk(..., settings->ijk_distance_mode == MODE_ABSOLUTE, offset1, offset2, ...)`. With R, it calls `arc_data_r`; hence the IJK-mode distinction applies to center-word arcs, not R-format arcs.
4. On successful conversion, `ARC_FEED` receives the calculated center and the current position is updated to the arc endpoint. Error paths via `CHP` precede that publication.
5. The cutter-compensated entry path `convert_arc_comp1` likewise passes the IJK absolute-mode flag to `arc_data_comp_ijk`. Thus cutter compensation is not a reason to ignore the modal contract.
6. FreeCAD LinuxCNC post default preamble is `G17 G54 G40 G49 G80 G90`, **without G90.1/G91.1**. It cannot by itself certify the arc-center mode expected by upstream Path command geometry.

## Discriminating disconnected geometry fixture
Consider a G17 CCW quarter-circle starting at X10 Y0, ending X20 Y10, center X10 Y10, radius 10 (units mm). The correct center word depends on the *separate* arc mode:

```ngc
(Review-only: disconnected, not approved for a machine)
G21 G17 G90 G91.1
G0 X10 Y0
G3 X20 Y10 I0 J10 F100
M2
```

An **equivalent geometric arc** under G90.1 uses `I10 J10` instead. Swapping these I/J pairs without changing G90.1/G91.1 changes the interpreted center or yields a radius/geometry error. The expected geometry is a mathematical inference from start/center/end, **not** an executed LinuxCNC result. In the same fixture, G90 remains absolute for X/Y in both cases.

**Counterexample to the false inference:** `G90` in FreeCAD's preamble does *not* establish that `I10 J10` denotes an absolute center. `G91.1` must be explicit or inherited from a known interpreter state. Conversely, explicit G91.1 would be wrong for a producer emitting absolute I/J centers.

## Reproducible review matrix (not executed)
| Case | Setup | Expected distinction | Evidence status |
|---|---|---|---|
| A | G91.1, start (10,0), end (20,10), I0 J10 | center (10,10), R10 | numeric inference |
| B | G90.1, same, I10 J10 | same geometry | numeric inference |
| C | G91.1 with I10 J10 | different center (20,10), degenerate end radius; likely interpreter error | numeric inference; precise error unverified |
| D | G90.1 with I0 J10 | different center (0,10); start/end radii differ | numeric inference; precise error unverified |
| E | G90 G91.1 | endpoint absolute, center incremental | source-confirmed mode separation |
| F | G18/G19 with proper K/I or J/K | plane permutation respected | source-confirmed dispatch; execution unverified |
| G | R-format arc with either IJK mode | R branch independent of IJK flag | source-confirmed |
| H | Cutter comp active | compensated IJK parser also receives absolute-mode flag | source-confirmed conditional |

For any future executable test: freeze LinuxCNC revision, ensure all NC files run **only** in isolated simulation on a verified `[self-hosted, openpressbrake]` runner, capture interpreter return, canonical arc center/turn and actual configuration. Do not dispatch hosted Actions or operate a physical machine. A test passing on the correct-mode pair does not prove what FreeCAD's actual producer emits.

## Outstanding producer-side trace
Find a real FreeCAD CAM operation that creates `Path.Command('G2'/'G3', ...)` or the C++ Path geometry emission, with its IJK construction. Record the start and center coordinate used and distinguish `center - start` from `center`. Inspect an upstream unit test asserting I/J values if available. **Only after this evidence** should a post change (explicit G91.1 or G90.1) be proposed. The `Command.py` post UI path is not that evidence. If source access remains poor, stop plasma micro-audits and rotate to HostMot2/Mesa or realtime scheduling.

## Claims and gates
SOURCE-CONFIRMED: LinuxCNC v2.9.10 mode setting, plane dispatch, arc_data_ijk boolean, R branch, FreeCAD pinned default preamble. NUMERIC INFERENCE: fixture geometry. TEST-CONFIRMED: **none for PLASMA-210**. No build, test, machine, evaluator, lab compute, or workflow execution; no new LAB_COMPUTE_LOG row. No blind key accessed. Existing graduated levels, independent personnel-safety authority, OpenPressBrake G0/G1 physical HOLD and evaluation gates unchanged.

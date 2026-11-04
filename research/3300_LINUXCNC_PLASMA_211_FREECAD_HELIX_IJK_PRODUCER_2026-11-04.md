# PLASMA-211 — FreeCAD CAM arc producer and incremental IJK evidence (2026-11-04)

**Scope:** 3300 machine-specific, NON-GRADUATED; source-inspection evidence only. **FreeCAD pinned revision:** `0cafef1e58284d08a244f9eba85aee0002e3e350`. LinuxCNC interpreter reference: v2.9.10 as in PLASMA-210. No runtime, machine, Actions or compute.

## Question and source inventory

PLASMA-210 established that G90/G91 and G90.1/G91.1 are separate modal groups, but could not identify FreeCAD's arc-coordinate producer. This lesson inspects the producer rather than extending post-format speculation.

* [FreeCAD helix.py lines 330–351](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Base/Generator/helix.py#L330-L351): computes `arcCenter` from three arc points, then explicitly `offset = arcCenter - arcPoints[i]`; passes `I: offset.x, J: offset.y` to `Path.Command(arcCmdName,...)`. Its finishing semicircles also supply offsets `±dx, ±dy`.
* [FreeCAD Path.cpp lines 67–75, 173–200](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/App/Path.cpp#L67-L75): `getArcLength` uses `absoluteCenter ? command.getCenter() : last + command.getCenter()`. The Toolpath loop initializes `absoluteCenter=false` and changes it on G90.1/G91.1, separately from endpoint G90/G91. The cycle-time loop likewise tracks both modes.
* [FreeCAD TestPathCore.py lines 193–212](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/CAMTests/TestPathCore.py#L193-L212): upstream **test definition**, not a test executed this session, uses `G0 X2 Y0; G3 X3 Y1 I0 J1` and equivalent `G90.1; G3 X3 Y1 I2 J1`, checking both against `2+pi/2` length.
* [FreeCAD LinuxCNC post](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py): prior PLASMA-207/210 found default G90 without explicit arc-center mode. This source trace does not imply every FreeCAD operation uses the helix producer.

## Result: a concrete incremental-center producer exists

For helix's generated arcs, I/J are **start-relative center offsets**, not absolute center coordinates. FreeCAD's own Path core assumes incremental centers by default and contains an explicit test for both representations. Thus a LinuxCNC adapter that receives helix-style Path commands should establish **G91.1 explicitly** before arcs rather than relying on an inherited controller mode. G90 is not a substitute. This closes the specific 'no producer found' gap from PLASMA-210; it does **not** prove all CAM operations, third-party imported paths, or postprocessor configurations share that contract.

**Geometry check (analytical, not executed):** start (2,0), center (2,1), end (3,1), G3 quarter circle. Under G91.1 use I0 J1; under G90.1 use I2 J1. FreeCAD's upstream length fixture expects initial G0 length 2 plus quarter arc length π/2. If G90.1 accidentally remains active with I0 J1, the center becomes (0,1), radii from start/end are unequal, and the intended arc is invalid. This is a mode-contract failure, not modal suppression of I/J.

## Reproducible disconnected verification plan

1. Inspect pinned helix.py and confirm center-minus-start arithmetic; vary starting XY while keeping local arc geometry constant. Expected I/J unchanged.
2. Inspect Path.cpp and confirm G90.1 changes center interpretation without changing endpoint mode. Expected length equivalence for the two upstream test paths.
3. Run upstream `TestPathCore.test51` in a pinned FreeCAD test environment; record actual exit, output and environment **before** upgrading evidence to TEST-CONFIRMED.
4. Generate one helix Path command and pass through LinuxCNC post; inspect preamble and I/J words, including inch conversion; record exact command output.
5. In disconnected LinuxCNC sim, compare explicit G91.1 vs explicit G90.1 on the fixture. Freeze expected canonical geometry first. Never run on a physical machine.
6. Negative controls: imported absolute-center Path commands, G18/G19, R arcs, G91 endpoint mode, and mixed-mode toolpaths. Do not generalize helix findings to these without tracing their producers.

## Evidence ledger and implementation boundary

| Claim | Evidence | Classification | Limitation |
|---|---|---|---|
| Helix producer computes start-relative I/J | pinned helix.py lines 332–340 | SOURCE-CONFIRMED | only this producer |
| FreeCAD Path core tracks independent center mode | pinned Path.cpp lines 67–75, 173–200 | SOURCE-CONFIRMED | source logic, no runtime |
| Upstream test defines equivalent absolute/incremental examples | pinned TestPathCore.py lines 193–212 | TEST-DEFINITION INSPECTED | test not run |
| LinuxCNC post should explicitly establish G91.1 for known incremental producer | cross-source compatibility deduction | DESIGN RECOMMENDATION | not a committed post patch; mixed producer audit needed |
| All FreeCAD CAM operations generate incremental IJK | not established | UNKNOWN | survey other producers |
| QtPlasmaC physical cutting behavior | not tested | UNKNOWN | no machine authorization |

**Next work:** Rotate to 4000 HostMot2/Mesa servo-thread ordering or motion realtime internals for broader LinuxCNC information gain. Reopen FreeCAD arc topic only to survey a *different* producer or run a bounded pinned post/interpreter test. Keep independent personnel safety, blind gates, graduated modules and physical restrictions unchanged. No GitHub-hosted runner.

# PLASMA-209 — FreeCAD MachineState tracked-word closure (2026-11-04)

**Status:** SOURCE-CONFIRMED narrow; NON-GRADUATED; NO EXECUTION.

## Immutable sources
FreeCAD commit `0cafef1e58284d08a244f9eba85aee0002e3e350`:
- [MachineState.py](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Base/MachineState.py), class `MachineState`, `Tracked`, `addCommand`.
- [Processor.py](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/Processor.py), postable command loop and `_convert_move`.
- [linuxcnc_post.py](https://github.com/FreeCAD/FreeCAD/blob/0cafef1e58284d08a244f9eba85aee0002e3e350/src/Mod/CAM/Path/Post/scripts/linuxcnc_post.py), default preamble.

## Resolved question from PLASMA-208
`MachineState.Tracked` is explicitly **X Y Z A B C F S T Coolant WCS Spindle ReturnMode G0F**. **I, J, K and R are not tracked.** Consequently the common formatter's condition `parameter in self.machine_state.Tracked and self.machine_state.previous[parameter] == current_value` **cannot suppress repeated I/J/K/R arc-center words**. This closes the conditional omission concern in PLASMA-208 for the inspected revision; it does not prove that the upstream Path producer supplies correct arc-center values.

The postable loop calls `machine_state.addCommand(cmd)` **before** `convert_command_to_gcode(cmd)`. `addCommand` saves `previous = getState()` before applying tracked parameters; the formatter compares against that prior snapshot. Thus identical tracked endpoints may be suppressed while unchanged I/J offsets are still emitted. `MachineState.addGcodeText` parses only G17/G18/G19 from raw text, not G90.1/G91.1 or arbitrary modal state. An `as-is` annotation resets tracked state to unknown and forwards raw text; it does not establish arc-center compatibility.

## Reproducible review fixtures (NOT RUN)
1. Two successive G17 G2 commands with different X/Y endpoints but identical I/J: both I and J must remain in formatter output if present in each command's parameters. Record exact strings in an isolated FreeCAD harness.
2. Two identical G1 XYZ commands: the second may lose duplicate tracked coordinates; distinguish this intentional optimization from arc-center handling.
3. G18 G2 with I/K/J: plane-normal J is excluded regardless of tracking; I/K remain eligible. For G19, I excluded.
4. Set `OUTPUT_DOUBLES=false`, send G2 with repeated I/J, verify that I/J are not suppressed; then compare `OUTPUT_DOUBLES=true`.
5. Use explicit G91.1 versus G90.1 on the LinuxCNC v2.9.10 interpreter with a non-origin arc start. This is **not** a FreeCAD test and requires a separate, permitted executable oracle.

## Important remaining contract
FreeCAD's LinuxCNC default preamble `G17 G54 G40 G49 G80 G90` specifies endpoint distance mode but not arc-center distance mode. `_convert_move` formats Path.Command I/J/K as supplied; it does not derive centers or choose incremental versus absolute center mode. The Path.Command **producer**, LinuxCNC stable G90.1/G91.1 implementation, and real postprocessor arc fixture remain uninspected here. Do not declare output compatible or defective until those are reconciled.

## Evidence and limitations
**SOURCE-CONFIRMED:** tracked set excludes IJKR; state snapshot before formatting; plane-normal omission; default preamble gap. **INFERENCE:** the specific paired-arc fixture will retain both I/J words, conditional on producer supplying them. **UNKNOWN:** producer IJK convention, stable interpreter behavior, runtime results and QtPlasmaC acceptance. **TEST-CONFIRMED:** none. No LinuxCNC/FreeCAD runtime, self-hosted or hosted Actions, compute, or physical machine operation. Existing independent personnel-safety authority, blind evaluation gates, graduated levels and OpenPressBrake physical HOLD remain unchanged.

## Next highest-value question
Trace the actual FreeCAD Path geometry/arc command constructor, or LinuxCNC 2.9.10 interpreter G90.1/G91.1 if constructor evidence is not accessible. Stop this plasma branch if no new implementation information emerges; rotate to 4000 HostMot2/Mesa realtime behavior. Never run GitHub-hosted compute.

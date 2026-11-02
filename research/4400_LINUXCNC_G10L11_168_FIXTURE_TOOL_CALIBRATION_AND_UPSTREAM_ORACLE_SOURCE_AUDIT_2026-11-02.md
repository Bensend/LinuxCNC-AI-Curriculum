# 4000-LC-G10L11-168 — G10 L11 fixture-referenced tool calibration: interpreter, rotation, G92, and upstream oracle

**Session:** 2026-11-02 19:33Z UTC. **Status:** 4000 implementation research, NON-GRADUATED. 3100 mill/VMC and 3400 router transfer. **Evidence:** SOURCE-CONFIRMED + DOC-CONFIRMED + UPSTREAM TEST SOURCE/EXPECTED INSPECTED; **NOT RUN / no TEST-CONFIRMED claim**.

## Why this is incremental
The course already has G10 L20 rotated-workpiece (G10-128), M61/G43 tool identity (M61-165), and G38 probe failure/position material. This investigation instead resolves the *G10 L11 fixture-referenced tool-table calculation*, its independence from current G5x and G92, the upstream test that already covers this, and a development-only G68.2 rejection. Do not claim the general G10 or probing mechanisms were newly discovered.

## Exact provenance
- Stable **LinuxCNC v2.9.10** (tag); `src/emc/rs274ngc/interp_convert.cc` blob `f01a359652d588d59c9e210fa441a99d2ee19598`, `Interp::convert_modal_0` ~3734, `Interp::convert_setup_tool` ~3984–4180.
- Stable `src/emc/rs274ngc/interp_find.cc`, `Interp::find_current_in_system_without_tlo` ~536–612.
- Development pinned **67437d8865e431a9a33f74cee912dbf891d3b4c5**, `interp_convert.cc` blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`, `convert_setup_tool` ~4765–4960; `interp_find.cc` ~661–740.
- Existing upstream stable executable-test **source** `tests/interp/g10/g10-l11/test.ngc` blob `be03aeca10c9ded386850df884b0e40b7ef945e4`; `test.sh` blob `29ef11d7a757643b30f60a59e19e745511b01d1d`; `test.tbl` contains `T1 P1 X0 Y0 Z0 ;`; `expected` blob `fea3844f76357826ac4421e5939afb2395901e30`.
- Official LinuxCNC 2.9 [G10 L10/L11](https://linuxcnc.org/docs/2.9/html/gcode/g-code.html): L10 is workpiece-relative; L11 references G59.3 with G52/G92 excluded. Source and documentation agree for this narrow behavior. No forum anecdote promoted to implementation fact.

## Source-level call flow and state
1. `convert_modal_0(G_10)` dispatches L1/L10/L11 to `convert_setup_tool`, rather than G10 L2/L20 coordinate-origin setter. This changes a **tool-table entry**, not the G59.3 origin.
2. `find_tool_index(settings, toolno, &idx)` resolves the selected P tool. Empty axis/radius/orientation input is rejected. The caller's G10 checks remain relevant; do not treat a free-standing expression as permission to edit nonexistent tools.
3. L1 is direct assignment. For L10, `destination_system=settings->origin_index`. For L11, `destination_system=9` (G59.3) regardless of currently selected G54–G59.3.
4. `find_current_in_system_without_tlo` reconstructs the machine-side coordinate from the current programmed position by **adding** current G92/axis offsets, current G5x origin and active tool offset; then subtracts the *destination* system origin and inverse-rotates its XY. It finally subtracts active G92 again. The name “without_tlo” does **not** mean the calculation ignores the currently applied tool offset; it removes its effect from the coordinate conversion.
5. For L11 **only**, if `parameters[5210]` signals active G92, `convert_setup_tool` adds back `parameters[5211..5219]` after that helper. This cancels the helper's G92 subtraction. For L10 the G92 adjustment remains. For XY, the requested coordinate is subtracted, then rotated by the destination system rotation; a single-axis X or Y update preserves the other tool-offset component in the rotated basis. For Z, the assignment is `tool_table[idx].offset.tran.z = PROGRAM_TO_USER_LEN(tz - block->z_number)`.
6. `SET_TOOL_TABLE_ENTRY(idx,...)` propagates the edited record. For nonrandom changers with the selected tool loaded, index 0 is copied/updated; the code updates stored-tool `#5401..#5409` including `#5403`. The source comment explicitly distinguishes stored offsets from the **currently applied** `#5081..#5089`. Therefore editing a tool entry is not equivalent to reissuing G43. Do not infer physical displacement from this source trace.
7. **Version delta:** development `convert_setup_tool` rejects calculated L10/L11 when `settings->g68_active` (tilted work plane G68.2), while direct L1 is exempt. Stable v2.9.10 has no corresponding guard in this function. This is a source delta, **not** a verified runtime result on either version.

## Independently inspectable upstream test — already exists
`tests/interp/g10/g10-l11/test.ngc` sets G54..G59.2 offsets/rotations and G59.3 Z=-27, then visits machine Z=-30 under G54 and G55 and edits T1 with L11 Z0 / Z1. The frozen `expected` contains `SET_TOOL_TABLE_ENTRY` Z **-3** / **-4**. It then enables G92 under G56, switches back to G54 and G55, and repeats. Expected entries remain **-3** / **-4** despite the G92 state and active work-coordinate changes. The test prints `#5403` after tool loading, but **does not verify #5083, active G43 reload, physical probe switch, or real motion**. Its `rs274 -g ... -t ...` execution is interpreter/canonical trace, not a real machine.

### Independent arithmetic for the frozen Z oracle
At machine Z=-30 and G59.3 Z=-27, with desired fixture Z=0, the computed tool Z offset is `-30 - (-27) - 0 = -3`; desired fixture Z=1 yields `-4`. This is an arithmetic cross-check of the **inspected expected output**, not a new execution or blind precommitment. G54 Z=-3 and G55 Z=-6 are deliberately different, yet not used as L11 reference.

## Coverage gaps / useful next tests
| Question | Existing test? | Additional predeclared control | Evidence |
|---|---|---|---|
| G59.3 Z reference invariant across active G54/G55 | Yes, expected -3/-4 | Reuse existing upstream test | Expected inspected, NOT RUN |
| G92 independence | Yes, after G92 applied | Reuse upstream test | Expected inspected, NOT RUN |
| G59.3 XY **rotation** with L11 single-axis preservation | No: fixture R0 | Add rotated G59.3 and prior nonzero tool XY; compare L11 X-only to X+Y; freeze numerical expected before run | UNKNOWN runtime |
| Stored tool #5403 versus applied #5083 before/after G43 | No | Sim-only copy of tool table, explicit G43 state snapshots; no physical tool movement | UNKNOWN runtime |
| L10 vs L11 with G92 and different G5x | No direct matched A/B | Separate clean interpreter invocations, compare canonical SET_TOOL_TABLE_ENTRY | SOURCE-CONFIRMED distinction, runtime UNKNOWN |
| Development G68.2 L11 guard | No stable fixture coverage | Version-specific isolated interpreter error oracle with valid tilted-plane setup | SOURCE-CONFIRMED guard, runtime UNKNOWN |

## Failure and integration implications
A CAM/probing macro that writes `G10 L10` when it intends fixture-relative `L11` can store a work-offset-dependent tool value; a macro that assumes `G10 L11` immediately reapplies the tool length may read a new stored `#5403` while motion still uses a prior applied offset. Both are plausible integration errors inferred from the code, **not observed field failures**. G10 edits persist to the tool table; testing must use a disposable simulation copy. A simulated canonical `STRAIGHT_TRAVERSE` in the upstream oracle is not authorization to run that program on a machine.

## Adversarial handoff / open uncertainty
1. Misleading premise: “G10 L11 uses the active G54 rotation because G54 is selected.” **Reject:** it uses destination system 9, including that fixture's rotation.
2. Version discriminator: “Both stable and development accept L11 while G68.2 is active.” **Reject as universal:** development explicitly rejects calculated L10/L11; stable behavior under tilted planes is not claimed.
3. Diagnostic: a tool table changes but the GUI still reports old applied TLO. Trace `#5403` versus `#5083` and G43 reload before diagnosing lost persistence.
4. Novel transfer question for a fresh learner: G59.3 R30, current G54 R0, existing tool X/Y nonzero, command `G10 L11 P1 X0`. Which tool-offset basis must be preserved? **Expected reasoning:** preserve component along fixture's rotated Y basis, not current G54 Y; inspect the X-only branch and `rotate` calls. **NOT independently evaluated**.

**Uncertainty queue:** G59.3 rotated-XY partial-axis oracle and G43 applied-state test are 4000 implementation extensions, MEDIUM, **non-graduated**; neither licenses physical-machine testing. Existing source and upstream oracle reduce duplication; no new lab justified until qualified disconnected runner. No evaluator exposed/graded; existing graduated levels remain closed.

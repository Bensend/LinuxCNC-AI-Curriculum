# TOOL-113 — G10 L10 versus L11: calculated tool offset, G59.3 fixture, G52/G92, and G43 application

**Status:** 4000 LinuxCNC source investigation, 3100 mill / 3200 lathe transfer; NON-GRADUATED. **Evidence:** SOURCE/DOC-CONFIRMED static; numerical example INFERENCE; TEST-CONFIRMED none. **Inspected:** LinuxCNC v2.9.10 annotated tag peeled to `86cdca76fa2a36274c432caa21952b23c267989a` (2026-07-02 tag) and development `06864e23559e70463fc7112d5ce77138bcbc288c` (commit 2026-11-01T02:13:18Z). This audit was performed 2026-11-01, not a claim that the implementation was newly published today.

## Question and predecessor control

How do L10 and L11 calculate a *stored* tool offset, how do G52/G92 and the fixture rotation enter, when does it become the *applied* tool-length offset, and does development's G68.2 change the contract? Full historical `PROGRESS.md` mechanism scan found earlier G38/G10 L20 probing, G43.2 inherited motion, TWP-111/112, and MILL-36 tool-change work, **not** a source trace of G10 L10/L11. This is tool calibration, not a new physical safety finding. Prior TWP findings remain authoritative for G68 coordinate transforms.

## Documentation contract

Official [stable G10 L10/L11 G-code reference](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc) says L10 computes an entry relative to current G5x and G52/G92 state; L11 computes as if G59.3 were active without G52/G92. A subsequent G43 reload is needed to apply the newly stored offset. The [tool compensation reference](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/tool-compensation.adoc) describes the distinction as current fixture versus fixture 9. Both require a valid tool P and disallow cutter compensation.

## Exact execution trace

1. [`interp_check.cc::check_g_codes`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_check.cc) permits G10 L0/L1/L2/L10/L11/L20, validates integer P and P>=1 for tool-table operations. [`interp_convert.cc::convert_modal_0`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) routes L1/L10/L11 to `convert_setup_tool`.
2. [`convert_setup_tool`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) finds the tool index; L1 writes axis values directly. For L10, `destination_system=settings->origin_index`; for L11, `destination_system=9` (G59.3). It invokes `find_current_in_system_without_tlo` and calculates each specified axis as *calculated current coordinate minus requested coordinate*. Unspecified axes are preserved, including rotation-aware X-only and Y-only handling.
3. [`interp_find.cc::find_current_in_system_without_tlo`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_find.cc) starts with current programmed coordinates, adds G52/G92 axis offsets, rotates by current XY rotation, adds current G5x origin and **active tool offset**, subtracts the selected destination G5x origin, applies inverse destination rotation, and subtracts G52/G92 offsets. The name `without_tlo` means it *undoes* the currently applied TLO to calculate a replacement; it does **not** mean it ignores TLO in its arithmetic.
4. L11 specifically adds the G52/G92 offset back to the helper's result when parameter 5210 indicates active offsets, removing that offset's effect on fixture calibration. This correction is performed in the destination coordinate system. The resulting stored offset is in user/machine units after `PROGRAM_TO_USER_LEN`.
5. [`emccanon.cc::SET_TOOL_TABLE_ENTRY`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc) flushes segments and queues `EMC_TOOL_SET_OFFSET`; [Task's `EMC_TOOL_SET_OFFSET_TYPE`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc) routes the command to IO and enqueues interpreter synchronization. The nonrandom changer mirrors a modified loaded tool to spindle slot 0; random and nonrandom tool index handling differ. **Stable IO:** [`ioControl.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/iotask/ioControl.cc) and `ioControl_v2.cc` copy the orientation/offset into `CANON_TOOL_TABLE`, call `tooldata_put`, then `tooldata_save`. **Development IO refactor:** [`Task::emcToolSetOffset`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/taskclass.cc) performs the equivalent put/save directly. This closes the source-level default IO path, but a successful physical calibration or durable write on an installed controller remains untested.
6. [`convert_tool_length_offset(G_43)`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc) loads the tool table's selected offset into the *applied* tool-offset state. Parameter [`#5401..#5409`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_parameter_def.hh) reports the loaded tool's **stored** offsets, while `#5081..#5089` reports the **applied** TLO. Do not mistake a tool-table edit for an already applied motion transform.

## Predeclared arithmetic example — SOURCE-DERIVED, NOT RUN

Use program units mm, zero XY rotations and the following consistent synthetic interpreter state: current Z=7; active G52/G92 Z axis offset=3 with parameter 5210 active and 5213=3; current G54 origin Z=20; active applied tool Z offset=5; stored G54 origin Z=20 and G59.3 origin Z=30. Both commands request `Z1` for the same valid tool P1. The helper produces:

| Operation | Helper Z calculation | L11 G52/G92 undo | New stored tool Z |
|---|---|---|---|
| `G10 L10 P1 Z1` | 7+3+20+5−20−3 = **12** | none | **11** |
| `G10 L11 P1 Z1` | 7+3+20+5−30−3 = **2** | +3 → **5** | **4** |

These are **alternative** runs from identical initial state, not sequential commands. The numbers describe interpreter arithmetic, **not measured machine motion**. A controller test must inspect the tool table, `#5403` (when P1 is loaded), `#5083`, and coordinates after explicit G43 reload, using an isolated disposable tool table.

## Version boundary

The inspected [development `convert_setup_tool`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc) adds `CHKS(settings->g68_active && !direct)`: while G68.2 is active, **L10/L11 are rejected**; L1 is not blocked by this particular guard. Stable v2.9.10 has no native G68.2 (see [TWP-111](4400_LINUXCNC_TWP_111_G682_FRAME_CHAIN_VS_KINEMATICS_SOURCE_AUDIT_2026-11-01.md)). This is a versioned parser rule, not proof of all possible remapped G68 behavior.

## Failure paths and uncertainties

- Invalid/missing P, absent tool-table entry, active cutter compensation, and G68.2+L10/L11 in development are distinct rejection points; identify which layer rejects the command.
- An incorrect G59.3 reference, stale tool table, wrong tool P, active coordinate rotation, or incorrect G43 reload can produce incorrect calibration even when the parser accepts the command.
- Both inspected default IO paths attempt tool-table persistence; actual save success, database-mode behavior, applied offset, and position changes require runtime evidence; none was obtained. No source-only calculation authorizes an unattended probing or physical calibration operation.

## Minimal verification and falsifier

On a positively qualified disconnected `[self-hosted, openpressbrake]` LinuxCNC installation, use an existing simulator with a disposable tool table containing P1. Freeze current G5x, G52/G92, TLO, units and rotation; compare two **freshly reset** runs of the L10 and L11 commands above. Capture `#5403`, `#5083`, table file, G43 reload, interpreter errors, version and exit status. For development, attempt L11 under active G68.2 and then after G69; expect a parser error only in the active-plane case. **NOT RUN.** A different stored Z than 11/4 under the frozen synthetic state falsifies the calculation and requires revisiting coordinate conventions and state initialization.

**Transfer:** Tool setter/lathe offsets, probing workflow, and OpenPressBrake/plasma integration must keep calibrated machine datum separate from process offsets. This is a controller calibration boundary, not an independent personnel-safety authority.

**Next:** [practical guide](../guides/3100-3200-4000-linuxcnc-g10-tool-calibration-fixture-q-preflight-2026-11-01.md), [checkpoint](../checkpoints/20261101T114000Z-4000-linuxcnc-g10-tool-table-next.md).

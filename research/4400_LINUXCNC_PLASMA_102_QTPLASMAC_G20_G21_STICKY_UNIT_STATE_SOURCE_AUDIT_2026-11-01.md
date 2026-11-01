# 4000-LC-PLASMA-102 — QtPlasmaC G20/G21 state does not return to native units

**2026-11-01 | 3300 plasma CAM / 4000 LinuxCNC implementation | NON-GRADUATED, SOURCE-CONFIRMED conditional, NOT RUN.** This is a new **unit-mode state-lifetime** mechanism. It is distinct from [PLASMA-39](4400_LINUXCNC_PLASMA_39_QTPLASMAC_HOLE_FILTER_COORDINATE_STATE_SOURCE_AUDIT_2026-10-31.md) (coordinate tracking) and [PLASMA-81](4400_LINUXCNC_PLASMA_81_QTPLASMAC_MODAL_ARC_LASTG_AND_G911_REWRITE_SOURCE_AUDIT_2026-10-31.md) (modal rewrite). Neither prior audit establishes unit-mode return behavior.

## Pinned source and exact path

- LinuxCNC stable **v2.9.10** (peeled source commit `86cdca76fa2a36274c432caa21952b23c267989a`), [`src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob **`4cdae156b94b607bd2514b1573baabc83f396f23`**: `__init__` ~65–81; `parse_code` ~285–293; `set_default_units` **548–562**; `get_hole_diameter` **855–889**; `overburn` **891–930**.
- LinuxCNC development pinned **`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`**, [same file](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/qtplasmac/qtplasmac_gcode.py), blob **`aeff3b6103f8c17a1e845b0f835f9ec9f30210b5`**: `parse_code` ~361–366; `set_default_units` **633–647**; `get_hole_diameter` **1000–1034**. The same branches remain in the inspected revision.
- Official [QtPlasmaC units and cutter-compensation documentation](https://www.linuxcnc.org/docs/2.9/html/plasma/qtplasmac.html) says material settings use INI machine units. That is **not** proof that every mixed-unit G-code program is supported. [Official G20/G21 documentation](https://www.linuxcnc.org/docs/2.9/html/gcode/g-code.html) defines program unit selection.

**Execution path:** INI machine units -> QtPlasmaC filter constructor (`units`, initial `unitMultiplier=1`, default `minDiameter`/overcut length) -> `process_file` -> `parse_code` detects G20/G21 -> `set_default_units` mutates *filter* state -> later G02/G03 `do_arc` -> `check_if_hole` -> `get_hole_diameter` and possible `overburn` -> generated G-code -> LinuxCNC interpreter. Filter state is not interpreter state or machine feedback.

## Mechanism and numeric discriminator

`set_default_units` has **no branch resetting `unitMultiplier` to 1** when a program returns to its machine's native units. It also does not restore `minDiameter` and `ocLength` to native defaults on that return.

For a **metric INI** (initial filter `unitMultiplier=1`, `minDiameter=32 mm`, `ocLength=4 mm`), separate lines `G20` then `G21` yield:

| State after line | Interpreter intended program units | Filter `unitMultiplier` | Filter `minDiameter` | Filter default `ocLength` |
|---|---|---:|---:|---:|
| Initially | metric | 1 | 32 | 4 |
| G20 | inch | 0.03937 | 1.26 | 0.157 |
| G21 | metric | **0.03937 (stale)** | **1.26 (stale)** | **0.157 (stale)** |

For an inch INI, `G21` then `G20` analogously leaves `unitMultiplier=25.4`, `minDiameter=32`, `ocLength=4` in an inch program.

**Conditional hole example (metric INI, material kerf 1.2 mm, `#<holes>=1`, explicit full-circle `G3 X20 Y20 I5 J0` from X20 Y20):** `get_hole_diameter` without G41 uses `2*sqrt(I²+J²) + kerfWidth/2*unitMultiplier`. Before a unit switch the filter compares **10.6 mm** with the 32 mm threshold and emits the reduced-feed M67. After `G20; G21`, the same geometry compares **10.023622 mm** with **1.26 mm**, so the source branch does **not** emit the hole slow-down. This is an arithmetic prediction from filter source, **not a run result**. Actual arc acceptance, previous modal state and torch behavior require independent execution.

A post that alternates units within one file can thus affect small-hole detection and overcut even after restoring G21/G20. Merely adding a native-unit command at the end does not reset this filter state.

## Evidence ledger, limits, and next verification

| Claim | Class | Evidence | Scope / uncertainty |
|---|---|---|---|
| Return to native units does not reset multiplier/defaults | **SOURCE-CONFIRMED** | Stable 548–562; development 633–647 | Only pinned revisions |
| Hole diameter/threshold branch changes as calculated | **SOURCE-CONFIRMED arithmetic / INFERENCE end-to-end** | Stable 855–889; development 1000–1034 | Need actual filtered file and canonical motion |
| A real plasma cut is mis-sized | **UNKNOWN** | No physical observation | Not claimed |

**Frozen software-only discriminators (NOT RUN):** U102-1 native G21 control; U102-2 G20->G21 with identical explicit arc; U102-3 G21->G20 inch-INI mirror; U102-4 compare `minDiameter`, `ocLength`, emitted M67/M62 and filtered coordinates. Capture INI, material file, input, filtered output, stderr, exit and interpreter result. Do not infer a PASS from source inspection. Run only on independently qualified disconnected `[self-hosted, openpressbrake]` compute; no torch or machine I/O.

**Practical post contract:** Emit a single program-unit mode matching the INI, avoid switching G20/G21 inside a QtPlasmaC job, retain explicit G02/G03 for auto-hole processing, and validate any externally sourced mixed-unit DXF/CAM job before execution. This is a source-derived conservative recommendation, not a statement that all mixed-unit programs are invalid.

**Dependency / next:** [3300/4000 practical guide](../guides/3300-linuxcnc-plasma-kerf-compensation-units-cam-post-handoff-2026-11-01.md); [PLASMA-103](4400_LINUXCNC_PLASMA_103_G411_KERF_HAL_LEADIN_OVERCUT_SOURCE_DOC_AUDIT_2026-11-01.md); [checkpoint](../checkpoints/20261101T053300Z-4000-linuxcnc-plasma-kerf-units-next.md). 1000/2000/F02/3000 remain CLOSED; no safety or evaluator gate changes.